//
//  CollectionViewModelState.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-19.
//

import Foundation

/// Type define possible states for `CollectionViewModel`
enum CollectionViewModelState {
    
    // View not busy
    case idle
    
    // View busy refreshing its content
    case refreshing
    
    // View busy fetching additional data
    case fetching
    
    // View busy layout new items
    case inserting(numberOfItems: Int)
    
    // View busy displaying data error
    case error
}

// MARK: - Conform to `Equatable`
extension CollectionViewModelState: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        
        switch(lhs, rhs) {
            
        case (.idle, .idle), (.refreshing, .refreshing), (.fetching, .fetching), (.error, .error):
            return true
            
        case let (.inserting(lNumberOfItems), .inserting(rNumberOfItems)):
            return lNumberOfItems == rNumberOfItems
            
        default:
            return false
        }
    }
}
