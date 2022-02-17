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
        let viewController = ListViewController()
        navigationController.pushViewController(viewController, animated: false)
    }
}
