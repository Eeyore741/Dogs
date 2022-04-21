//
//  CollectionItem.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-17.
//

import Foundation

/// Protocol describes requirements for entity to be presented in collection
protocol CollectionItem {
    
    /// UUID to utilize withing app lifecycle
    var uuid: UUID { get }
    
    /// Title of collection item
    var title: String { get }
    
    /// Url of image representing collection item
    var imageUrl: URL { get }
}
