//
//  DogBreedsObjectTests.swift
//  DogsTests
//
//  Created by vitalii.kuznetsov on 2022-04-17.
//

import XCTest
@testable import Dogs

final class DogBreedsListObjectTests: XCTestCase {

    func testInit() {
        let sut0 = DogBreedsListObject(message: ["any"])
        
        XCTAssertEqual(sut0.message.count, 1)
        XCTAssertEqual(sut0.message[0], "any")
    }
    
    func testDecodable() throws {
        guard let dummyPath = Bundle(for: Self.self).url(forResource: "DogBreedsObject", withExtension: "json") else { fatalError("No resource") }
        let dummyData = try Data(contentsOf: dummyPath)
        
        let sut0 = try JSONDecoder().decode(DogBreedsListObject.self, from: dummyData)
        
        XCTAssertEqual(sut0.message.count, 50)
        XCTAssertEqual(sut0.message[0], "https://images.dog.ceo/breeds/labradoodle/labradoodle-forrest.png")
        XCTAssertEqual(sut0.message[25], "https://images.dog.ceo/breeds/hound-basset/n02088238_9626.jpg")
        XCTAssertEqual(sut0.message[49], "https://images.dog.ceo/breeds/spaniel-irish/n02102973_3344.jpg")
    }
}
