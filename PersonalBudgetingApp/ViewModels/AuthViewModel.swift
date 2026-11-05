//
//  AuthViewModel.swift
//  PersonalBudgetingApp
//
//  Created by Mike Putnam on 10/20/26.
//
import SwiftUI
import Observation
@Observable
@MainActor
final class AuthViewModel {
    var name = ""
    var email = ""
    var password = ""
    var confirmPassword = ""
    var errorMessage: String?
    var isAuthenticated : Bool {token != nil}
    var isLoading = false
    var token : String?
    var infoMessage: String?
    
    private let authService = AuthService()
    var failedRules: [PasswordRule] {
        PasswordRule.allCases.filter{!$0.isSatisfied(by: password)}
    }
    var passwordsMatch: Bool {
        !confirmPassword.isEmpty && confirmPassword == password
    }
    var isEmailValid: Bool {
        email.contains("@") && email.contains(".")
    }
    var canRegister: Bool {
        !name.isEmpty &&
        isEmailValid &&
        failedRules.isEmpty &&
        passwordsMatch
    }
    var canLogin: Bool {
        isEmailValid &&
        !password.isEmpty
    }
    func login() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            token = try await authService.login(email: email, password: password)
            // Save token securely (e.g., Keychain)
           
        } catch {
            errorMessage = "Invalid credentials or server error."
        }
    }
    func register() async {
        isLoading = true

//        if(canRegister) {
//            errorMessage = "Confirmation password does not match password"
//            return
//        }
        defer { isLoading = false }
        
        do {
            infoMessage = try await authService.register(name: name,
                                                       email: email,
                                                       password: password)
            password = ""
            confirmPassword = ""
            // Save token securely (e.g., Keychain)
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

//
//#Preview {
//    AuthViewModel()
//}
