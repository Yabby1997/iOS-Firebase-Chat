//
//  AuthenticationViewModel.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/17.
//

import Combine
import Foundation

enum AuthenticationViewModelErrors: LocalizedError {
    case nameNotProvided
    
    var errorDescription: String? {
        switch self {
        case .nameNotProvided: return "이름이 입력되지 않았습니다."
        }
    }
}

protocol AuthenticationViewModelProtocol {
    var deinitSignalPublisher: PassthroughSubject<Void, Never> { get }
    var userDidAuthenticatedPublisher: PassthroughSubject<Void, Never> { get }
    var errorPublisher: AnyPublisher<Error?, Never> { get }
    var isAuthenticateButtonEnabledPublisher: AnyPublisher<Bool, Never> { get }
    
    var name: String { get set }
    var profileImage: Data? { get set }
    
    func authenticateButtonDidTap()
}

final class AuthenticationViewModel: AuthenticationViewModelProtocol {
    var deinitSignalPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    var userDidAuthenticatedPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    var errorPublisher: AnyPublisher<Error?, Never> { $error.eraseToAnyPublisher() }
    var isAuthenticateButtonEnabledPublisher: AnyPublisher<Bool, Never> { $name.map { !$0.isEmpty }.eraseToAnyPublisher() }
    
    @Published var name: String = ""
    @Published var profileImage: Data? = nil
    
    @Published private var error: Error? = nil
    
    private var cancellables: Set<AnyCancellable> = []
    private let authenticateUserUseCase: AuthenticateUserUseCaseProtocol
    
    init(authenticateUserUseCase: AuthenticateUserUseCaseProtocol) {
        self.authenticateUserUseCase = authenticateUserUseCase
    }
    
    func authenticateButtonDidTap() {
        if name.isEmpty { return error = AuthenticationViewModelErrors.nameNotProvided }
        
        authenticateUserUseCase.authUser(name: name)
            .sink { [weak self] completion in
                guard case .failure(let error) = completion else { return }
                self?.error = error
            } receiveValue: { [weak self] signal in
                self?.userDidAuthenticatedPublisher.send(signal)
            }
            .store(in: &self.cancellables)
    }
}
