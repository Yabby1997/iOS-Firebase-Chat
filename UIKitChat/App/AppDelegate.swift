//
//  AppDelegate.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/17.
//

import UIKit

import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
