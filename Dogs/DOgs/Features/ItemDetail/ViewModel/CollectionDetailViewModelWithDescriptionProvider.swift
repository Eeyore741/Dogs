//
//  CollectionDetailViewModelWithDescriptionProvider.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-20.
//

import UIKit

/// Type conforming `CollectionDetailViewModel` utilizing injection of `CollectionItemDescriptionProvider` 
final class CollectionDetailViewModelWithDescriptionProvider: CollectionDetailViewModel {
    
    // DI
    let item: CollectionItem
    let descriptionProvider: CollectionItemDescriptionProvider
    let imageCache: ImageCache
    
    // Conformance
    var title: String { self.item.title }
    var imageUrl: URL { self.item.imageUrl }
    private(set) var text: NSAttributedString = NSAttributedString()
    
    private(set) var state: CollectionDetailViewModelState = .idle {
        didSet {
            guard self.state != oldValue else { return }
            
            self.delegate?.collectionDetailViewModel(self, didChangeState: self.state)
        }
    }
    
    weak var delegate: CollectionDetailViewModelDelegate? = nil
    
    lazy private var titleAttributes: [NSAttributedString.Key : Any] = {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.white
        shadow.shadowBlurRadius = 4.0
        
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 40.0) as Any,
            NSAttributedString.Key.kern: NSNumber(floatLiteral: 14.0),
            NSAttributedString.Key.shadow: shadow
        ]
        
        return attributes
    }()
    
    lazy private var descriptionAttributes: [NSAttributedString.Key : Any] = {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.white
        shadow.shadowBlurRadius = 4.0
        
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 20.0) as Any,
            NSAttributedString.Key.kern: NSNumber(floatLiteral: 2.0),
            NSAttributedString.Key.shadow: shadow
        ]
        
        return attributes
    }()
    
    init(item: CollectionItem, descriptionProvider: CollectionItemDescriptionProvider, imageCache: ImageCache = ImageCache.makeWithTotalMegabyteLimit(2)) {
        self.item = item
        self.descriptionProvider = descriptionProvider
        self.imageCache = imageCache
    }
    
    func onViewDidLoad() {
        guard self.state != .refreshing else { return }
        
        self.state = .refreshing
        self.descriptionProvider.fetchDescriptionForItemWithUid(item.uuid) { [weak self] (result: Result<String, Error>) in
            guard let self = self else { return }
            
            switch result {
                
            case .success(let description):
                let attributedTitle = NSMutableAttributedString(string: self.item.title, attributes: self.titleAttributes)
                let attributedDescription = NSMutableAttributedString(string: "\n\n" + description, attributes: self.descriptionAttributes)
                attributedTitle.append(attributedDescription)
                self.text = attributedTitle
                self.state = .idle
                
            case .failure(_):
                self.text = NSAttributedString()
                self.state = .error
            }
        }
    }
}
