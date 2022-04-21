//
//  CollectionDetailViewModelState.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-20.
//

import Foundation

/// Type defining possible states for `CollectionDetailViewModel` instance
enum CollectionDetailViewModelState {
    
    // Instance not busy
    case idle
    
    // Instance busy refreshing data
    case refreshing
    
    // Instance busy displaying error
    case error
}

// MARK: - Conforming `Equatable`
extension CollectionDetailViewModelState: Equatable { }
