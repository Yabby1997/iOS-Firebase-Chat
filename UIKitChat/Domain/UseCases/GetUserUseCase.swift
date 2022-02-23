//
//  GetUserUseCase.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/18.
//

import Combine

class GetUserUseCase: GetUserUseCaseProtocol {
    
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func getUser(uid: String) -> AnyPublisher<ChattingUser, Error> {
        return userRepository.fetchUser(uid: uid)
    }
}
