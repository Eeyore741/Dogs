//
//  CollectionDetailViewModel.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-20.
//

import UIKit

/// Protocol defines requirements to serve `CollectionDetailController` instance
protocol CollectionDetailViewModel: AnyObject {
    
    /// Title to display on top of view
    var title: String { get }
    
    /// Text to display in text view
    var text: NSAttributedString { get }
    
    /// Remote imge to display on top of view under next
    var imageUrl: URL { get }
    
    /// Image cache to reuse for remote image access
    var imageCache: ImageCache { get }
    
    /// Current state of view model
    var state: CollectionDetailViewModelState { get }
    
    /// Delegate for current instance
    var delegate: CollectionDetailViewModelDelegate? { get set }
    
    /// Action of view finished loading
    func onViewDidLoad()
}

/// Delegate requirements for `CollectionDetailViewModel` instance
protocol CollectionDetailViewModelDelegate: AnyObject {
    
    /// View model did change its state
    func collectionDetailViewModel(_ viewModel: CollectionDetailViewModel, didChangeState state: CollectionDetailViewModelState)
}
