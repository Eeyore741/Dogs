//
//  ImageCache.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-17.
//

import UIKit

typealias ImageCache = NSCache<NSString, UIImage>

extension ImageCache {
    
    /// Make instance with memory cost limit
    /// - Parameter totalMegabyteLimit: Memory cost in megabytes
    /// - Returns: `ImageCache` instance with memory cost limit
    static func makeWithTotalMegabyteLimit(_ totalMegabyteLimit: Int) -> ImageCache {
        let instance = ImageCache()
        instance.totalCostLimit = 1024 * 1024 * totalMegabyteLimit
        return instance
    }
}
