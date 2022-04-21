//
//  CollectionDetailViewModelWithDescriptionProviderTests.swift
//  DogsTests
//
//  Created by vitalii.kuznetsov on 2022-04-21.
//

import XCTest
@testable import Dogs

class CollectionDetailViewModelWithDescriptionProviderTests: XCTestCase {
    
    func testInit() {
        let item = DogBreedObject(uuid: UUID(), title: "any", imageUrl: URL(fileURLWithPath: "any"))
        let provider = CollectionItemDescriptionProviderDummy()
        provider.delay = 0.5
        provider.resultStub = .failure(RemoteApiError.fetchError)
        let sut0 = CollectionDetailViewModelWithDescriptionProvider(item: item, descriptionProvider: provider)
        
        XCTAssertEqual(sut0.state, .idle)
        
        sut0.onViewDidLoad()
        XCTAssertEqual(sut0.state, .refreshing)
        
        let waitExpectation0 = XCTestExpectation()
        waitExpectation0.isInverted = true
        self.wait(for: [waitExpectation0], timeout: 1)
        
        XCTAssertEqual(sut0.state, .error)
        
        provider.resultStub = .success("any")
        
        sut0.onViewDidLoad()
        XCTAssertEqual(sut0.state, .refreshing)
        
        let waitExpectation1 = XCTestExpectation()
        waitExpectation1.isInverted = true
        self.wait(for: [waitExpectation1], timeout: 1)
        
        XCTAssertEqual(sut0.state, .idle)
    }
}
