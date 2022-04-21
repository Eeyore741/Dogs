//
//  RemoteApiClient.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-17.
//

import Foundation

/// Error enum utilized in `RemoteApiClient`
enum RemoteApiError: Error {
    case fetchError
}

/// Result type utilized in `RemoteApiClient`
typealias RemoteApiResult<Data: Decodable> = Result<Data, RemoteApiError>

/// Client designrated to perform `RequestConvertible` with expectation of `RemoteApiResult`
class RemoteApiClient {
    
    private let session: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
    
    /// Perform request with completion handler injected with decodable result
    func fetchJsonDecodable<DecodableData: Decodable>(request: URLRequest, withCompletionHandler handler: @escaping (RemoteApiResult<DecodableData>) -> Void) {
        self.session.dataTask(with: request) { (data, response, error) in
            guard
                error == nil,
                let data = data else { return handler(RemoteApiResult.failure(RemoteApiError.fetchError)) }
            
            let result: RemoteApiResult<DecodableData>
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(DecodableData.self, from: data)
                result = RemoteApiResult.success(decodedData)
            } catch {
                result = RemoteApiResult.failure(RemoteApiError.fetchError)
            }
            handler(result)
        }.resume()
    }
}
