//
//  DogBreedObject.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-19.
//

import Foundation

/// Dog breed object to utilize application needs
struct DogBreedObject {
    let uuid: UUID
    let title: String
    let imageUrl: URL
}

extension DogBreedObject {
    
    /// Helper initializer
    /// - Parameter messageUrl: URL string provided by Dog.Ceo
    init(withMessageUrl messageUrl: String) throws {
        guard let url = URL(string: messageUrl) else { throw DogBreedObjectError.decode }
        
        self.uuid = UUID()
        self.title = url.pathComponents[2].replacingOccurrences(of: "-", with: " ").capitalized
        self.imageUrl = url
    }
}

extension DogBreedObject: Equatable { }

enum DogBreedObjectError: Error {
    case decode
}
