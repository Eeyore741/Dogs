//
//  CollectionViewLayout.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-19.
//

import UIKit

/// Generic flow layout with rounded square cells
final class CollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        
        let cellSide: CGFloat = (availableWidth / 2).rounded(.down) - 14.0
        
        self.itemSize = CGSize(width: cellSide, height: cellSide)
        self.sectionInset = UIEdgeInsets(top: 14.0, left: 14.0, bottom: 42.0, right: 14.0)
        self.sectionInsetReference = .fromSafeArea
    }
}
