//
//  RandomTextProvider+CollectionItemDescriptionProvider.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-20.
//

import Foundation

// MARK: - Conform to `CollectionItemDescriptionProvider`
extension RandomTextProvider: CollectionItemDescriptionProvider {
    
    /// Fetch remote text description for item by its id
    /// - Parameters:
    ///   - uuid: Items id
    ///   - handler: Completion handler
    func fetchDescriptionForItemWithUid(_ uuid: UUID, withCompletionHandler handler: @escaping (Result<String, Error>) -> Void) {
        
        DispatchQueue.global().async {
            let description = self.generateTextWithSentancesCount(25, wordsUpperBound: 15, andLettersUpperBound: 15)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.66) {
                handler(.success(description))
            }
        }
    }
}
