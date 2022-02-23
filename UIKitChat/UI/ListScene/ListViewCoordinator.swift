//
//  ListViewCoordinator.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/17.
//

import UIKit

final class ListViewCoordinator: AnyCoordinator {
    func start() {
        guard let navigationController = presenter as? UINavigationController else { return }
        
        let firebaseNetworkService = FirebaseNetworkService()
        let userRepository = UserRepository(firebaseNetworkService: firebaseNetworkService)
        let getUserUseCase = GetUserUseCase(userRepository: userRepository)
        let viewModel = ListViewModel(getUserUseCase: getUserUseCase)
        let viewController = ListViewController(viewModel: viewModel)
        
        viewModel.deinitSignalPublisher
            .sink { [weak self] _ in
                navigationController.popViewController(animated: true)
                self?.removeFromParent()
            }
            .store(in: &self.cancellables)
        
        viewModel.userNotAuthenticatedPublisher
            .sink { [weak self] _ in
                self?.userNotAuthenticated()
            }
            .store(in: &self.cancellables)
        
        navigationController.pushViewController(viewController, animated: false)
    }
                
    private func userNotAuthenticated() {
        let sceneIdentifier = UUID()
        let authenticationViewCoordinator = AuthenticationViewCoordinator(
            sceneIdentifier: sceneIdentifier,
            presenter: presenter,
            parent: self
        )
        children[sceneIdentifier] = authenticationViewCoordinator
        authenticationViewCoordinator.start()
    }
}
