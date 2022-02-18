//
//  AuthenticateUserUseCaseProtocol.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/18.
//

import Combine

protocol AuthenticateUserUseCaseProtocol {
    func authUser(chattingUser: ChattingUser) -> AnyPublisher<Void, Error>
}
