//
//  PasswordRule.swift
//  PersonalBudgetingApp
//
//  Created by Mike Putnam on 11/4/26.
//

import Foundation
enum PasswordRule: CaseIterable, Identifiable {
    case minLength, uppercase, lowercase, number, symbol
    var id: Self { self }
    
    var message: String {
        switch self {
        case .minLength: "At least 8 characters"
        case .uppercase: "At least 1 upper case character"
        case .lowercase: "At least 1 lower case character"
        case .number: "At least 1 number"
        case .symbol: "At least 1 symbol"
        }
    }
    
    func isSatisfied(by password: String) -> Bool {
        switch self {
        case .minLength: password.count >= 8
        case .uppercase: password.rangeOfCharacter(from: .uppercaseLetters) != nil
        case .lowercase: password.rangeOfCharacter(from: .lowercaseLetters) != nil
        case .number: password.rangeOfCharacter(from: .decimalDigits) != nil
        case .symbol: password.contains { !$0.isLetter && !$0.isNumber && !$0.isWhitespace}
            
        }
    }
}
