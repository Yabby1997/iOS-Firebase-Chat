//
//  AppCoordinator.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/17.
//

import Foundation

final class AppCoordinator: AnyCoordinator {
    func start() {
        let sceneIdentifier = UUID()
        let coordinator = ListViewCoordinator(
            sceneIdentifier: sceneIdentifier,
            presenter: presenter,
            parent: self
        )
        children[sceneIdentifier] = coordinator
        coordinator.start()
    }
}
