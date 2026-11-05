//
//  AuthService.swift
//  PersonalBudgetingApp
//
//  Created by Mike Putnam on 10/20/26.
//

import Foundation
import WebKit
struct AuthRequestLogin: Codable {
    let username: String
    let password: String
}
struct AuthRequestRegistration: Codable {
    let name: String
    let username: String
    let password: String
//    let confirmPassword: String
}
struct AuthResponse: Codable {
    let token: String
}

class AuthService {
    private let baseURL = URL(string: "http://localhost:8080/auth")!
    struct MessageResponse: Codable {
        let message: String
    }
    func login(email: String, password: String) async throws -> String {
        var request = URLRequest(url: baseURL.appendingPathComponent("/login"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = AuthRequestLogin(username: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
        return authResponse.token
    }
    func register(name: String,
                  email: String,
                  password: String) async throws -> String {
        var request = URLRequest(url: baseURL.appendingPathComponent("/register"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = AuthRequestRegistration(name: name,
                   username: email,
                   password: password)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        #if DEBUG
        print("REGISTER", http.statusCode, String(data: data, encoding: .utf8) ?? "")
        #endif

        guard (200...299).contains(http .statusCode) else {
       // use the server's message if it sent one, e.g. "Email already registered"
       let serverMessage = try? JSONDecoder().decode(MessageResponse.self, from: data).message
       throw AuthError.server(serverMessage ?? "Registration failed (\(http.statusCode)).")
   }

   // success: return the server's message if present, else a default
   return (try? JSONDecoder().decode(MessageResponse.self, from: data).message)
       ?? "Verification email sent to \(email). Check your inbox to activate your account."
        let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
        return authResponse.token
    }
    
    enum AuthError: LocalizedError {
        case server(String)
        var errorDescription: String? {
            switch self { case .server(let msg): msg }
        }
    }
}
