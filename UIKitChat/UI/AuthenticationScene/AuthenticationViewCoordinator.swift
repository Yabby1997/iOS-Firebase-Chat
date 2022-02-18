//
//  AuthenticationViewCoordinator.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/18.
//

import Foundation

class AuthenticationViewCoordinator: AnyCoordinator {
    func start() {
        let viewController = AuthenticationViewController()
        presenter.present(viewController, animated: true)
    }
}
