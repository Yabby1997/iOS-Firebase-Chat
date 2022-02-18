//
//  GetUserUseCase.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/18.
//

import Combine

class GetUserUseCase: GetUserUseCaseProtocol {
    func getUser() -> AnyPublisher<ChattingUser?, Error> {
        return Just(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
