//
//  CollectionViewModel.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-17.
//

import Foundation

/// Protocol for view model serving to `CollectionListController` instance
protocol CollectionViewModel: AnyObject {
    
    /// Current state of view model
    var state: CollectionViewModelState { get }
    
    /// Title to dispaly on top of view
    var title: String { get }
    
    /// Number of items being hold
    var numberOfItems: Int { get }
    
    /// Delegate for current view model instance
    var delegate: CollectionViewModelDelegate? { get set }
    
    /// View triggers data refresh
    func onViewRefresh()
    
    /// View did finished laying out new items
    func onViewDidInsertItems()
    
    /// View has reached end of list
    func onViewDidReachEndOfList()
    
    /// View did select cell
    func onViewSelectedItemAtIndexPath(_ indexPath: IndexPath)
    
    /// View has cell to fill with data
    func fillCell(_ cell: CollectionCellView, atIndexPath indexPath: IndexPath)
}

/// Delegate to serve `CollectionViewModel` instance
protocol CollectionViewModelDelegate: AnyObject {
    
    /// View model did change its state
    func collectionViewModel(_ model: CollectionViewModel, didChangeState state: CollectionViewModelState)
}
