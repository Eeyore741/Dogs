//
//  DogBreedObjectTests.swift
//  DogsTests
//
//  Created by vitalii.kuznetsov on 2022-04-21.
//

import XCTest
@testable import Dogs

final class DogBreedObjectTests: XCTestCase {

    func testInit() {
        let uuid = UUID()
        let title = "any"
        let imageUrl = URL(fileURLWithPath: "any")
        let sut0 = DogBreedObject(uuid: uuid, title: title, imageUrl: imageUrl)
        
        XCTAssertEqual(sut0.uuid, uuid)
        XCTAssertEqual(sut0.title, title)
        XCTAssertEqual(sut0.imageUrl, imageUrl)
    }
    
    func testInitWithMessage() throws {
        guard let message = URL(string: "https://images.dog.ceo/breeds/spaniel-sussex/n02102480_7850.jpg") else {
            fatalError()
        }
        let sut0 = try DogBreedObject(withMessageUrl: message.absoluteString)
        
        XCTAssertEqual(sut0.title, "Spaniel Sussex")
        XCTAssertEqual(sut0.imageUrl, message)
    }
}
