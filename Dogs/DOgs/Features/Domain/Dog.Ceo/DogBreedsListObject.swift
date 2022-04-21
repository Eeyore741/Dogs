//
//  DogBreedsListObject.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-17.
//

import Foundation

/// Direct representation of dog breeds list we get from remote API (zero cost abstraction)
/// https://dog.ceo/api/breeds/image/random/50
struct DogBreedsListObject {
    var message: [String]
}

extension DogBreedsListObject: Decodable { }
