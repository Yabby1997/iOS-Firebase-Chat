//
//  ListViewModel.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/17.
//

import Combine
import Foundation

protocol ListViewModelProtocol {
    var deinitSignalPublisher: PassthroughSubject<Void, Never> { get }
    var userNotAuthenticatedPublisher: PassthroughSubject<Void, Never> { get }
    var chattingUserPublisher: AnyPublisher<ChattingUser?, Never> { get }
    var errorPublisher: AnyPublisher<Error?, Never> { get }
    
    func viewWillAppear()
}

final class ListViewModel: ListViewModelProtocol {
    var deinitSignalPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    var userNotAuthenticatedPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    var chattingUserPublisher: AnyPublisher<ChattingUser?, Never> { $chattingUser.eraseToAnyPublisher() }
    var errorPublisher: AnyPublisher<Error?, Never> { $error.eraseToAnyPublisher() }
    
    @Published private var error: Error? = nil
    @Published private var chattingUser: ChattingUser? = nil
    private var cancellables: Set<AnyCancellable> = []
    
    private let getUserUseCase: GetUserUseCaseProtocol
    
    init(getUserUseCase: GetUserUseCaseProtocol) {
        self.getUserUseCase = getUserUseCase
    }
    
    func viewWillAppear() {
        guard let currentUserUid = AuthManager.currentUser?.uid else { return userNotAuthenticatedPublisher.send(()) }
        
        getUserUseCase.getUser(uid: currentUserUid)
            .sink { [weak self] completion in
                guard case .failure(let error) = completion else { return }
                self?.error = error
                self?.userNotAuthenticatedPublisher.send(())
            } receiveValue: { [weak self] chattingUser in
                self?.chattingUser = chattingUser
            }
            .store(in: &self.cancellables)
    }
}
