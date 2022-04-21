//
//  RandomTextProviderTests.swift
//  DogsTests
//
//  Created by vitalii.kuznetsov on 2022-04-21.
//

import XCTest
@testable import Dogs

final class RandomTextProviderTests: XCTestCase {

    func testInit() {
        XCTAssertNoThrow(RandomTextProvider())
    }
    
    func testGenerateWordWithLettersCount() {
        let sut0 = RandomTextProvider()
        XCTAssertEqual(sut0.generateWordWithLettersCount(9).count, 9)
    }
    
    func testGenerateSentanceWithWordsCount() {
        let sut0 = RandomTextProvider()
        let sentance = sut0.generateSentanceWithWordsCount(9, andLettersUpperBound: 9)
        let words = sentance.split(separator: " ")
        
        XCTAssertEqual(words.count, 9)
        words.forEach {
            XCTAssertLessThanOrEqual($0.count, 9)
        }
    }
    
    func testGenerateTextWithSentancesCount() {
        let sut0 = RandomTextProvider()
        let text = sut0.generateTextWithSentancesCount(9, wordsUpperBound: 9, andLettersUpperBound: 9)
        let sentances = text.split(separator: ".")
        
        sentances.forEach {
            let words = $0.split(separator: " ")
            XCTAssertLessThanOrEqual(words.count, 9)
            
            words.forEach {
                XCTAssertLessThanOrEqual($0.count, 9)
            }
        }
    }
}
