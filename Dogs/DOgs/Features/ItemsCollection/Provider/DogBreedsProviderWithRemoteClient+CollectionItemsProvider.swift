//
//  DogBreedsProviderWithRemoteClient+CollectionItemsProvider.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-20.
//

import UIKit

// Conforming types of Doc.Ceo domain to requirements of application

extension DogBreedObject: CollectionItem { }

extension DogBreedsProviderWithRemoteClient: CollectionItemsProvider {
    
    func fetchItemsWithOffset(_ offset: Int, completionHandler: @escaping (Result<[CollectionItem], Error>) -> Void) {
        self.fetchDogBreedsWithCompletionHandler { result in
            switch result {
                
            case .success(let breeds):
                completionHandler(.success(breeds))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
