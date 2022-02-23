//
//  AuthenticationViewCoordinator.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/18.
//

import Foundation

class AuthenticationViewCoordinator: AnyCoordinator {
    func start() {
        let firebaseNetworkService = FirebaseNetworkService()
        let userRepository = UserRepository(firebaseNetworkService: firebaseNetworkService)
        let authenticateUserUseCase = AuthenticateUserUseCase(userRepository: userRepository)
        let viewModel = AuthenticationViewModel(authenticateUserUseCase: authenticateUserUseCase)
        let viewController = AuthenticationViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        
        viewModel.deinitSignalPublisher
            .sink { [weak self] _ in
                self?.presenter.dismiss(animated: true)
            }
            .store(in: &self.cancellables)
        
        presenter.present(viewController, animated: true)
    }
}
