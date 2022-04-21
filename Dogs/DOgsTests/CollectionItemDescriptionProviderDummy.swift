//
//  CollectionItemDescriptionProviderDummy.swift
//  DogsTests
//
//  Created by vitalii.kuznetsov on 2022-04-21.
//

import Foundation
@testable import Dogs

final class CollectionItemDescriptionProviderDummy: CollectionItemDescriptionProvider {
    
    var delay: TimeInterval = 0
    var resultStub: (Result<String, Error>)? = nil
    
    func fetchDescriptionForItemWithUid(_ uuid: UUID, withCompletionHandler handler: @escaping (Result<String, Error>) -> Void) {
        guard let result = resultStub else { fatalError() }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.delay) {
            handler(result)
        }
    }
}
