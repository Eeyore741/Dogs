//
//  CollectionItemsProviderDummy.swift
//  DogsTests
//
//  Created by vitalii.kuznetsov on 2022-04-21.
//

import Foundation
@testable import Dogs

final class CollectionItemsProviderDummy: CollectionItemsProvider {

    var delay: TimeInterval = 0
    var resultStub: (Result<[CollectionItem], Error>)? = nil
    
    func fetchItemsWithOffset(_ offset: Int, completionHandler: @escaping (Result<[CollectionItem], Error>) -> Void) {
        guard let result = self.resultStub else { fatalError() }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.delay) {
            completionHandler(result)
        }
    }
}
