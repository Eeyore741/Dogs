//
//  ApplicationController.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-17.
//

import Foundation
import UIKit

final class ApplicationController {
    
    let navigationController: UINavigationController = UINavigationController()
    let imageCache: ImageCache = ImageCache.makeWithTotalMegabyteLimit(10)
    
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
    
    func makeCollectionDetailControllerWithItem(_ item: CollectionItem) -> CollectionDetailController {
        let provider = RandomTextProvider()
        let viewModel = CollectionDetailViewModelWithDescriptionProvider(item: item, descriptionProvider: provider, imageCache: self.imageCache)
        let controller = CollectionDetailController(viewModel: viewModel)
        
        return controller
    }
}
