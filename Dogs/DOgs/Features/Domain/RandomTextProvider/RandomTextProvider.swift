//
//  RandomTextProvider.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-20.
//

import Foundation

/// Simple type used to generate random words, sentences and texts
final class RandomTextProvider {
    
    private static let letterSet: Set<String> = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    private var randomNumberGenerator: SystemRandomNumberGenerator = SystemRandomNumberGenerator()
    
    /// Generate random word
    /// - Parameter length: Word length
    /// - Returns: Generated string
    func generateWordWithLettersCount(_ length: UInt) -> String {
        var result: String = String()
        (0 ..< length).forEach { _ in
            result += Self.letterSet.randomElement(using: &randomNumberGenerator) ?? result
        }
        return result
    }
    
    /// Generate random sentance
    /// - Parameters:
    ///   - wordsCount: Number of words in sentance
    ///   - lettersUpperBound: Upper bound for word length
    /// - Returns: Generated sentance
    func generateSentanceWithWordsCount(_ wordsCount: UInt, andLettersUpperBound lettersUpperBound: UInt) -> String {
        var result: String = String()
        (0 ..< wordsCount).forEach { index in
            let lettersCount: UInt = UInt.random(in: 1...lettersUpperBound, using: &self.randomNumberGenerator)
            let word = self.generateWordWithLettersCount(lettersCount)
            result += " " + (index == 0 ? word.capitalized : word)
        }
        return result + "."
    }
    
    /// Generate random text
    /// - Parameters:
    ///   - sentancesCount: Amount of sentances in text
    ///   - wordsUpperBound: Upper bound for number of words
    ///   - lettersUpperBound: Upper bound for word length
    /// - Returns: Generated text
    func generateTextWithSentancesCount(_ sentancesCount: UInt, wordsUpperBound: UInt, andLettersUpperBound lettersUpperBound: UInt) -> String {
        var result: String = String()
        (0 ..< sentancesCount).forEach { _ in
            let lettersCount: UInt = UInt.random(in: 1...lettersUpperBound, using: &self.randomNumberGenerator)
            let wordsCount: UInt = UInt.random(in: 1...wordsUpperBound, using: &self.randomNumberGenerator)
            let sentance: String = self.generateSentanceWithWordsCount(wordsCount, andLettersUpperBound: lettersCount)
            result += sentance
        }
        return result
    }
}
