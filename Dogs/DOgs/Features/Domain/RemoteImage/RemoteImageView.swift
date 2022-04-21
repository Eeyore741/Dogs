//
//  RemoteImageView.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-17.
//

import UIKit

/// Subclass of `UIImageView` extended with remote image source and caching support
final class RemoteImageView: UIImageView {
    
    var imageCache: ImageCache
    
    private let session: URLSession
    private var task: URLSessionDataTask? = nil {
        didSet {
            oldValue?.cancel()
            DispatchQueue.main.async { self.image = nil }
            task?.resume()
        }
    }
    
    /// Initialize instance of `RemoteImageView`
    /// - Parameters:
    ///   - imageCache: Optional image cache to utilize
    ///   - urlSession: Optional url session to utilize
    init(withImageCache imageCache: ImageCache? = nil, andUrlSession urlSession: URLSession? = nil) {
        self.imageCache = imageCache ?? ImageCache.makeWithTotalMegabyteLimit(10)
        self.session = urlSession ?? URLSession(configuration: URLSessionConfiguration.ephemeral)
        
        super.init(frame: CGRect.zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Set image with remote url
    /// - Parameter imageUrl: Remote image url
    func setRemoteImageWithUrl(_ imageUrl: URL?) {
        DispatchQueue.global().async {
            guard let imageUrl = imageUrl else { return self.task = nil }
            
            let key = imageUrl.absoluteString
            
            if let image = self.imageCache.object(forKey: NSString(string: key)) {
                DispatchQueue.main.async { self.image = image }
            } else {
                self.task = self.session.dataTask(with: imageUrl) {(data, response, error) in
                    guard let data = data else { return }
                    
                    if let image = UIImage(data: data) {
                        self.imageCache.setObject(image, forKey: NSString(string: key))
                        self.setRemoteImageWithUrl(imageUrl)
                    }
                }
            }
        }
    }
}
