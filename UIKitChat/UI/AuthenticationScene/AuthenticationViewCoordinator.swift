//
//  AuthenticationViewCoordinator.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/18.
//

import Foundation
import UIKit

class AuthenticationViewCoordinator: AnyCoordinator {
    func start() {
        let firebaseNetworkService = FirebaseNetworkService()
        let userRepository = UserRepository(firebaseNetworkService: firebaseNetworkService)
        let authenticateUserUseCase = AuthenticateUserUseCase(userRepository: userRepository)
        let viewModel = AuthenticationViewModel(authenticateUserUseCase: authenticateUserUseCase)
        let viewController = AuthenticationViewController(viewModel: viewModel)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        viewModel.userDidAuthenticatedPublisher
            .sink { [weak self] _ in
                self?.userDidAuthenticated(presenter: navigationController)
            }
            .store(in: &self.cancellables)
        
        viewModel.deinitSignalPublisher
            .sink { [weak self] _ in
                self?.presenter.dismiss(animated: true)
            }
            .store(in: &self.cancellables)
        
        presenter.present(navigationController, animated: true)
    }
    
    private func userDidAuthenticated(presenter: UINavigationController) {
        let sceneIdentifier = UUID()
        let coordinator = ProfileImageSelectionViewCoordinator(
            sceneIdentifier: sceneIdentifier,
            presenter: presenter,
            parent: self
        )
        children[sceneIdentifier] = coordinator
        coordinator.start()
    }
}
