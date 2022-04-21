//
//  RemoteApiClientDummy.swift
//  DogsTests
//
//  Created by vitalii.kuznetsov on 2022-04-21.
//

import Foundation
@testable import Dogs

final class RemoteApiClientDummy<AnyDecodable: Decodable>: RemoteApiClient {
    
    var resultStub: (RemoteApiResult<AnyDecodable>)? = nil
    
    override func fetchJsonDecodable<D>(request: URLRequest, withCompletionHandler handler: @escaping (RemoteApiResult<D>) -> Void) where D : Decodable {
        guard let result = resultStub as? RemoteApiResult<D> else { fatalError() }
        
        handler(result)
    }
}
