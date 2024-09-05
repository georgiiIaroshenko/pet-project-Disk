//
//  LoginService.swift
//  Disk
//
//  Created by Георгий on 28.07.2024.
//

import Foundation

enum CheckResult {
    case invalidLogin
    case shortPassword
    case passworNotHaveDigits
    case passwordNotUppercased
    case passwordNotLowercased
    case passwordsMismatch
    case correct
}

final class LoginService {
    static let shared = LoginService()
    
    func checkCredentials(login: String, password: String, passwordTwo: String) -> CheckResult {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        guard emailPred.evaluate(with: login) else {
            return .invalidLogin
        }
        
        guard password.count >= 6 else {
            return .shortPassword
        }
        
        guard password.rangeOfCharacter(from: .decimalDigits) != nil else {
            return .passworNotHaveDigits
        }
        
        guard password.rangeOfCharacter(from: .lowercaseLetters) != nil else {
            return .passwordNotLowercased
        }
        
        guard password.rangeOfCharacter(from: .uppercaseLetters) != nil else {
            return .passwordNotUppercased
        }
        
        guard password == passwordTwo else {
            return .passwordsMismatch
        }
        
        return .correct
    }
}
