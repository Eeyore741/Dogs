//
//  CollectionCellView.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-17.
//

import UIKit

/// Collection cell with image view
final class CollectionCellView: UICollectionViewCell {
    
    override class var requiresConstraintBasedLayout: Bool { true }
    
    private var constraintsLayoutOnce: Bool = false
    private let remoteImageView: RemoteImageView = {
        let view = RemoteImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    var imageCache: ImageCache = ImageCache()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        guard self.constraintsLayoutOnce == false else { return }
        defer { self.constraintsLayoutOnce = true }
        
        self.remoteImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.remoteImageView)
        
        NSLayoutConstraint.activate([
            self.remoteImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.remoteImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.remoteImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.remoteImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        
        self.remoteImageView.layer.masksToBounds = true
        self.remoteImageView.layer.cornerRadius = 16.0
    }
    
    func setImage(_ image: String?) {
        DispatchQueue.main.async {
            guard let image = image, let url = URL(string: image) else {
                return self.remoteImageView.setRemoteImageWithUrl(nil)
            }
            self.remoteImageView.imageCache = self.imageCache
            self.remoteImageView.setRemoteImageWithUrl(url)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.setImage(nil)
    }
}
