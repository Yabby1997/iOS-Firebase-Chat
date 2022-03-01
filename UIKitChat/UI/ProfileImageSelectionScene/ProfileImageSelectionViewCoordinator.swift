//
//  ProfileImageSelectionViewCoordinator.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/03/01.
//

import UIKit

final class ProfileImageSelectionViewCoordinator: AnyCoordinator {
    func start() {
        let viewModel = ProfileImageSelectionViewModel()
        let viewController = ProfileImageSelectionViewController(viewModel: viewModel)
        
        guard let navigationController = presenter as? UINavigationController else { return }
        navigationController.pushViewController(viewController, animated: true)
        
        viewModel.deinitSignalPublisher
            .sink { _ in
                navigationController.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
}
