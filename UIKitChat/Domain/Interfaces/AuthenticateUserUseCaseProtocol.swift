//
//  AuthenticateUserUseCaseProtocol.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/18.
//

import Combine
import Foundation

protocol AuthenticateUserUseCaseProtocol {
    func authUser(name: String, profileImage: Data?) -> AnyPublisher<Void, Error>
}
