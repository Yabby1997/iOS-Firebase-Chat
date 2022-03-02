//
//  UserRepositoryProtocol.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/21.
//

import Combine
import Foundation

protocol UserRepositoryProtocol {
    func authUser(uid: String, name: String) -> AnyPublisher<Void, Error>
    func fetchUser(uid: String) -> AnyPublisher<ChattingUser, Error>
}
