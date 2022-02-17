//
//  SceneDelegate.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/17.
//

import UIKit

import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let rootViewController = UINavigationController()
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
        
        self.appCoordinator = AppCoordinator(presenter: rootViewController)
        self.appCoordinator?.start()
    }
}

