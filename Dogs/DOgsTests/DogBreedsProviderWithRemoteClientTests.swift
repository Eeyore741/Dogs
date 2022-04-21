//
//  DogBreedsProviderWithRemoteClientTests.swift
//  DogsTests
//
//  Created by vitalii.kuznetsov on 2022-04-21.
//

import XCTest
@testable import Dogs

final class DogBreedsProviderWithRemoteClientTests: XCTestCase {
    
    func testInit() {
        let client = RemoteApiClientDummy<DogBreedsListObject>()
        XCTAssertNoThrow(DogBreedsProviderWithRemoteClient(remoteApiClient: client))
    }
    
    func testFetchDogBreedsWithCompletionHandler() {
        let client = RemoteApiClientDummy<DogBreedsListObject>()
        client.resultStub = .success(DogBreedsListObject(message: ["https://images.dog.ceo/breeds/saluki/n02091831_8847.jpg"]))
        
        let sut0 = DogBreedsProviderWithRemoteClient(remoteApiClient: client)
        
        let expectation0 = self.expectation(description: "For success result")
        sut0.fetchDogBreedsWithCompletionHandler { (result: Result<[DogBreedObject], Error>) in
            if case .success(let objects) = result {
                XCTAssertEqual(objects.count, 1)
                XCTAssertEqual(objects[0].title, "Saluki")
                XCTAssertEqual(objects[0].imageUrl, URL(string: "https://images.dog.ceo/breeds/saluki/n02091831_8847.jpg"))
                expectation0.fulfill()
            }
        }
        
        client.resultStub = .failure(RemoteApiError.fetchError)
        let expectation1 = self.expectation(description: "For failure result")
        sut0.fetchDogBreedsWithCompletionHandler { (result: Result<[DogBreedObject], Error>) in
            if case .failure(let error) = result {
                XCTAssertTrue(error is DogBreedsProviderWithRemoteClientError)
                expectation1.fulfill()
            }
        }
        
        self.waitForExpectations(timeout: 1)
    }
    
    func testFetchItemsWithOffset() {
        let client = RemoteApiClientDummy<DogBreedsListObject>()
        client.resultStub = .success(DogBreedsListObject(message: ["https://images.dog.ceo/breeds/saluki/n02091831_8847.jpg"]))
        
        let sut0 = DogBreedsProviderWithRemoteClient(remoteApiClient: client)
        
        let expectation0 = self.expectation(description: "For success result")
        sut0.fetchItemsWithOffset(0) { (result: Result<[CollectionItem], Error>) in
            if case .success(let objects) = result {
                XCTAssertEqual(objects.count, 1)
                XCTAssertEqual(objects[0].title, "Saluki")
                XCTAssertEqual(objects[0].imageUrl, URL(string: "https://images.dog.ceo/breeds/saluki/n02091831_8847.jpg"))
                expectation0.fulfill()
            }
        }
        
        client.resultStub = .failure(RemoteApiError.fetchError)
        let expectation1 = self.expectation(description: "For failure result")
        sut0.fetchItemsWithOffset(0) { (result: Result<[CollectionItem], Error>) in
            if case .failure(let error) = result {
                XCTAssertTrue(error is DogBreedsProviderWithRemoteClientError)
                expectation1.fulfill()
            }
        }
        
        self.waitForExpectations(timeout: 1)
    }
}
