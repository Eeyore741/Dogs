//
//  DogBreedsProviderWithRemoteClient.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-19.
//

import Foundation

/// Error typealias for `DogBreedsProviderWithRemoteClient`
typealias DogBreedsProviderWithRemoteClientError = RemoteApiError

/// Provider type for `DogBreedObject` from Dog.Ceo domain, utilizing `RemoteApiClient` instance injection
final class DogBreedsProviderWithRemoteClient {
    
    private let remoteApiClient: RemoteApiClient
    
    private var request: URLRequest {
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random/50") else { fatalError() }
        
        return URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 2)
    }
    
    init(remoteApiClient: RemoteApiClient) {
        self.remoteApiClient = remoteApiClient
    }
    
    func fetchDogBreedsWithCompletionHandler(_ handler: @escaping (Result<[DogBreedObject], Error>) -> Void) {
        self.remoteApiClient.fetchJsonDecodable(request: self.request) { (result: RemoteApiResult<DogBreedsListObject>) in
            switch result {
                
            case .success(let dogBreedsObject):
                var successResult: Result<[DogBreedObject], Error>
                do {
                    let breedObjects = try dogBreedsObject.message.map { try DogBreedObject(withMessageUrl: $0) }
                    successResult = .success(breedObjects)
                } catch {
                    successResult = .failure(DogBreedsProviderWithRemoteClientError.fetchError)
                }
                handler(successResult)
                
            case .failure(_):
                handler(.failure(DogBreedsProviderWithRemoteClientError.fetchError))
            }
        }
    }
}
