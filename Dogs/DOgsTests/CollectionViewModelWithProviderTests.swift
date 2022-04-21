//
//  CollectionViewModelWithProviderTests.swift
//  DogsTests
//
//  Created by vitalii.kuznetsov on 2022-04-21.
//

import XCTest
@testable import Dogs

final class CollectionViewModelWithProviderTests: XCTestCase {
    
    func testInit() {
        let provider = CollectionItemsProviderDummy()//<DogBreedObject>()
        let cache = ImageCache()
        let sut0 = CollectionViewModelWithProvider(collectionItemsProvider: provider, imageCache: cache)
        
        XCTAssertEqual(sut0.title, "Pugs")
        XCTAssertEqual(sut0.state, .idle)
        XCTAssertEqual(sut0.numberOfItems, 0)
        XCTAssertNil(sut0.delegate)
    }
    
    func testOnViewRefresh() throws {
        let provider = CollectionItemsProviderDummy()
        let cache = ImageCache()
        let sut0 = CollectionViewModelWithProvider(collectionItemsProvider: provider, imageCache: cache)
        
        provider.resultStub = try .success([
            DogBreedObject(withMessageUrl: "https://images.dog.ceo/breeds/mexicanhairless/n02113978_1954.jpg"),
            DogBreedObject(withMessageUrl: "https://images.dog.ceo/breeds/hound-ibizan/n02091244_1000.jpg")
        ])
        provider.delay = 1
        
        sut0.onViewRefresh()
        XCTAssertEqual(sut0.state, .refreshing)
        
        let delayExpectation0 = XCTestExpectation()
        delayExpectation0.isInverted = true
        wait(for: [delayExpectation0], timeout: 2)
        
        XCTAssertEqual(sut0.numberOfItems, 2)
        XCTAssertEqual(sut0.state, .inserting(numberOfItems: 2))
        
        sut0.onViewDidInsertItems()
        XCTAssertEqual(sut0.state, .idle)
        
        provider.resultStub = .failure(RemoteApiError.fetchError)
        sut0.onViewRefresh()
        XCTAssertEqual(sut0.state, .refreshing)
        
        let delayExpectation1 = XCTestExpectation()
        delayExpectation1.isInverted = true
        wait(for: [delayExpectation1], timeout: 2)
        
        XCTAssertEqual(sut0.state, .error)
    }
    
    func testonViewDidReachEndOfList() throws {
        let provider = CollectionItemsProviderDummy()
        let cache = ImageCache()
        let sut0 = CollectionViewModelWithProvider(collectionItemsProvider: provider, imageCache: cache)
        
        provider.resultStub = try .success([
            DogBreedObject(withMessageUrl: "https://images.dog.ceo/breeds/mexicanhairless/n02113978_1954.jpg"),
            DogBreedObject(withMessageUrl: "https://images.dog.ceo/breeds/hound-ibizan/n02091244_1000.jpg")
        ])
        provider.delay = 1
        
        sut0.onViewDidReachEndOfList()
        XCTAssertEqual(sut0.state, .fetching)
        
        let delayExpectation0 = XCTestExpectation()
        delayExpectation0.isInverted = true
        wait(for: [delayExpectation0], timeout: 2)
        
        XCTAssertEqual(sut0.numberOfItems, 2)
        XCTAssertEqual(sut0.state, .inserting(numberOfItems: 2))
        
        sut0.onViewDidInsertItems()
        XCTAssertEqual(sut0.state, .idle)
        
        provider.resultStub = .failure(RemoteApiError.fetchError)
        sut0.onViewDidReachEndOfList()
        XCTAssertEqual(sut0.state, .fetching)
        
        let delayExpectation1 = XCTestExpectation()
        delayExpectation1.isInverted = true
        wait(for: [delayExpectation1], timeout: 2)
        
        XCTAssertEqual(sut0.state, .error)
    }
}
