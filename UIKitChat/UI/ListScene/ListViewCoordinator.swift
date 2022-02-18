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
        
        let viewModel = ListViewModel()
        let viewController = ListViewController(viewModel: viewModel)
        
        viewModel.deinitSignal
            .sink { [weak self] _ in
                navigationController.popViewController(animated: true)
                self?.removeFromParent()
            }
            .store(in: &self.cancellables)
        
        navigationController.pushViewController(viewController, animated: false)
    }
}
