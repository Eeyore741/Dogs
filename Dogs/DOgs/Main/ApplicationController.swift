//
//  ApplicationController.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-17.
//

import Foundation
import UIKit

/// Type represents application main entrance point, which orchestrates its behaviour (flow)
final class ApplicationController {
    
    private let navigationController: UINavigationController = UINavigationController()
    private let imageCache: ImageCache = ImageCache.makeWithTotalMegabyteLimit(10)
    
    /// Start application flow with window given
    /// - Parameter window: Window to start with
    func startWithWindow(_ window: UIWindow) {
        window.rootViewController = self.navigationController
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.navigationController.navigationBar.tintColor = .red.withAlphaComponent(0.9)
        
        let listController = self.makeCollectionListController()
        self.navigationController.pushViewController(listController, animated: false)
    }
}

// MARK: - Private factory helpers
private extension ApplicationController {
    
    /// Make items collection controller injected with dog breeds list provider
    /// - Returns: Items collection controller
    func makeCollectionListController() -> CollectionListController {
        let client = RemoteApiClient()
        let provider = DogBreedsProviderWithRemoteClient(remoteApiClient: client)
        let imageCache = self.imageCache
        let viewModel = CollectionViewModelWithProvider(collectionItemsProvider: provider, imageCache: imageCache)
        let controller = CollectionListController(viewModel: viewModel)
        
        viewModel.onDidSelectItem = { [weak self] item in
            guard let self = self else { return }
            
            let detailController = self.makeCollectionDetailControllerWithItem(item)
            self.navigationController.pushViewController(detailController, animated: true)
        }
        
        return controller
    }
    
    /// Make item detail controller injected with random text provider
    /// - Parameter item: Item to datail presentation
    /// - Returns: Item detail controller instance
    func makeCollectionDetailControllerWithItem(_ item: CollectionItem) -> CollectionDetailController {
        let provider = RandomTextProvider()
        let viewModel = CollectionDetailViewModelWithDescriptionProvider(item: item, descriptionProvider: provider, imageCache: self.imageCache)
        let controller = CollectionDetailController(viewModel: viewModel)
        
        return controller
    }
}
