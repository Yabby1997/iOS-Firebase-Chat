//
//  AuthManager.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/23.
//

import Combine

import FirebaseAuth

class AuthManager {
    
    enum Errors: LocalizedError {
        case signInError
        
        var errorDescription: String? {
            switch self {
            case .signInError: return "회원가입 중 에러가 발생했습니다. "
            }
        }
    }
    
    static var currentUser: User? {
        Auth.auth().currentUser
    }
    
    static func auth() -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            Auth.auth().signInAnonymously { result, error in
                if let error = error { return promise(.failure(error)) }
                guard let uid = result?.user.uid else { return promise(.failure(Errors.signInError)) }
                return promise(.success(uid))
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func signOut() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            do {
                try Auth.auth().signOut()
                return promise(.success(()))
            }
            catch {
                return promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
