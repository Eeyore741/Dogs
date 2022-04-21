//
//  CollectionViewModelWithProvider.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-19.
//

import Foundation

protocol CollectionItemsProvider {
    func fetchItemsWithOffset(_ offset: Int, completionHandler: @escaping (Result<[CollectionItem], Error>) -> Void)
}

/// Type conforming `CollectionViewModel` utilizing `collectionItemsProvider` injection
final class CollectionViewModelWithProvider: CollectionViewModel {

    // DI
    var onDidSelectItem: ((CollectionItem) -> Void)? = nil
    private let collectionItemsProvider: CollectionItemsProvider
    
    // Conformance
    var numberOfItems: Int { self.items.count }
    private(set) var title: String = "Pugs"
    private(set) var state: CollectionViewModelState = .idle {
        didSet {
            guard self.state != oldValue else { return }
            
            self.delegate?.collectionViewModel(self, didChangeState: self.state)
        }
    }
    weak var delegate: CollectionViewModelDelegate?
    
    private var items: [CollectionItem] = []
    private let imageCache: ImageCache
    
    init(collectionItemsProvider: CollectionItemsProvider, imageCache: ImageCache = ImageCache()) {
        self.collectionItemsProvider = collectionItemsProvider
        self.imageCache = imageCache
    }
    
    func onViewRefresh() {
        guard self.state != .refreshing else { return }
        
        self.items.removeAll()
        self.state = .refreshing
        
        self.collectionItemsProvider.fetchItemsWithOffset(0) { [weak self] (result: Result<[CollectionItem], Error>) in
            guard let self = self else { return }
            
            switch result {
                
            case .success(let items):
                self.items = items
                self.state = .inserting(numberOfItems: items.count)
                
            case .failure(_):
                self.state = .error
            }
        }
    }
    
    func onViewDidInsertItems() {
        self.state = .idle
    }
    
    func onViewDidReachEndOfList() {
        guard self.state != .fetching else { return }
        
        self.state = .fetching
        
        self.collectionItemsProvider.fetchItemsWithOffset(self.items.count) { [weak self] (result: Result<[CollectionItem], Error>) in
            guard let self = self else { return }
            
            switch result {
                
            case .success(let items):
                self.items += items
                self.state = .inserting(numberOfItems: items.count)
                
            case .failure(_):
                self.state = .error
            }
        }
    }
    
    func onViewSelectedItemAtIndexPath(_ indexPath: IndexPath) {
        let item = self.items[indexPath.item]
        self.onDidSelectItem?(item)
    }
    
    func fillCell(_ cell: CollectionCellView, atIndexPath indexPath: IndexPath) {
        let item = self.items[indexPath.item]
        
        cell.imageCache = self.imageCache
        cell.setImage(item.imageUrl.absoluteString)
    }
}
