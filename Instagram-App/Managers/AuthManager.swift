//
//  AuthManager.swift
//  Instagram-App
//
//  Created by Joseph Estanislao Calla Moreyra on 18/10/22.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    static let shared = AuthManager()
    
    let auth = Auth.auth()
    
    private init() {}
    
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    public func signIn(email: String, password: String,
                       completion: @escaping (Result<User, Error>) -> Void) {
        
    }
    
    public func signUp(email: String, password: String,
                       profilePicture: Data?,
                       completion: @escaping (Result<User, Error>) -> Void) {
        
    }
    
    public func signOut(completion: @escaping (Bool) -> Void) {
        
    }
    
}
