//
//  CollectionItemDescriptionProvider.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-20.
//

import UIKit

/// Protocol defines requirement for provider of text description
protocol CollectionItemDescriptionProvider {
    
    /// Fetch remote text description for item by its id
    func fetchDescriptionForItemWithUid(_ uuid: UUID, withCompletionHandler handler: @escaping (Result<String, Error>) -> Void)
}
