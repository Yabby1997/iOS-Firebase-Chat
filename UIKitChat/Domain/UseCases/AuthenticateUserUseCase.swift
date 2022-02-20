//
//  AuthenticateUserUseCase.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/20.
//

import Combine
import Foundation

class AuthenticateUserUseCase: AuthenticateUserUseCaseProtocol {
    func authUser(name: String, profileImageData: Data?) -> AnyPublisher<Void, Error> {
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
