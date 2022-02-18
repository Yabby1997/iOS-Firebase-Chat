//
//  CheckUserUseCaseProtocol.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/18.
//

import Combine

protocol GetUserUseCaseProtocol {
    func getUser() -> AnyPublisher<ChattingUser?, Error>
}
