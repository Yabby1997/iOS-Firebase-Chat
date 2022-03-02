//
//  AuthenticateUserUseCase.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/20.
//

import Combine
import Foundation

class AuthenticateUserUseCase: AuthenticateUserUseCaseProtocol {
    
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func authUser(name: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            var cancellables: Set<AnyCancellable> = []
            
            guard let self = self else { return }
            AuthManager.auth()
                .sink { completion in
                    guard case .failure(let error) = completion else { return }
                    return promise(.failure(error))
                } receiveValue: { [weak self] uid in
                    self?.userRepository.authUser(uid: uid, name: name)
                        .sink { completion in
                            guard case .failure(let error) = completion else { return }
                            AuthManager.signOut()
                                .sink { completion in
                                    guard case .failure(let error) = completion else { return }
                                    return promise(.failure(error))
                                } receiveValue: { _ in
                                    return promise(.success(()))
                                }
                                .store(in: &cancellables)
                            return promise(.failure(error))
                        } receiveValue: {
                            return promise(.success(()))
                        }
                        .store(in: &cancellables)
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
}
