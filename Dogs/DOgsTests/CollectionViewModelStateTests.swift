//
//  CollectionViewModelStateTests.swift
//  DogsTests
//
//  Created by vitalii.kuznetsov on 2022-04-21.
//

import XCTest
@testable import Dogs

final class CollectionViewModelStateTests: XCTestCase {
    
    func testInit() {
        _ = CollectionViewModelState.idle
        _ = CollectionViewModelState.fetching
        _ = CollectionViewModelState.refreshing
        _ = CollectionViewModelState.error
        _ = CollectionViewModelState.inserting(numberOfItems: 0)
    }
    
    func testEquatable() {
        XCTAssertEqual(CollectionViewModelState.idle, CollectionViewModelState.idle)
        XCTAssertNotEqual(CollectionViewModelState.idle, CollectionViewModelState.fetching)
        XCTAssertNotEqual(CollectionViewModelState.idle, CollectionViewModelState.refreshing)
        XCTAssertNotEqual(CollectionViewModelState.idle, CollectionViewModelState.error)
        XCTAssertNotEqual(CollectionViewModelState.idle, CollectionViewModelState.inserting(numberOfItems: 0))
        
        XCTAssertEqual(CollectionViewModelState.fetching, CollectionViewModelState.fetching)
        XCTAssertNotEqual(CollectionViewModelState.fetching, CollectionViewModelState.idle)
        XCTAssertNotEqual(CollectionViewModelState.fetching, CollectionViewModelState.refreshing)
        XCTAssertNotEqual(CollectionViewModelState.fetching, CollectionViewModelState.error)
        XCTAssertNotEqual(CollectionViewModelState.fetching, CollectionViewModelState.inserting(numberOfItems: 0))
        
        XCTAssertEqual(CollectionViewModelState.refreshing, CollectionViewModelState.refreshing)
        XCTAssertNotEqual(CollectionViewModelState.refreshing, CollectionViewModelState.fetching)
        XCTAssertNotEqual(CollectionViewModelState.refreshing, CollectionViewModelState.idle)
        XCTAssertNotEqual(CollectionViewModelState.refreshing, CollectionViewModelState.error)
        XCTAssertNotEqual(CollectionViewModelState.refreshing, CollectionViewModelState.inserting(numberOfItems: 0))
        
        XCTAssertEqual(CollectionViewModelState.error, CollectionViewModelState.error)
        XCTAssertNotEqual(CollectionViewModelState.error, CollectionViewModelState.fetching)
        XCTAssertNotEqual(CollectionViewModelState.error, CollectionViewModelState.idle)
        XCTAssertNotEqual(CollectionViewModelState.error, CollectionViewModelState.refreshing)
        XCTAssertNotEqual(CollectionViewModelState.error, CollectionViewModelState.inserting(numberOfItems: 0))
        
        XCTAssertEqual(CollectionViewModelState.inserting(numberOfItems: 0), CollectionViewModelState.inserting(numberOfItems: 0))
        XCTAssertNotEqual(CollectionViewModelState.inserting(numberOfItems: 0), CollectionViewModelState.inserting(numberOfItems: 1))
        XCTAssertNotEqual(CollectionViewModelState.inserting(numberOfItems: 0), CollectionViewModelState.fetching)
        XCTAssertNotEqual(CollectionViewModelState.inserting(numberOfItems: 0), CollectionViewModelState.idle)
        XCTAssertNotEqual(CollectionViewModelState.inserting(numberOfItems: 0), CollectionViewModelState.refreshing)
        XCTAssertNotEqual(CollectionViewModelState.inserting(numberOfItems: 0), CollectionViewModelState.error)
    }
}
