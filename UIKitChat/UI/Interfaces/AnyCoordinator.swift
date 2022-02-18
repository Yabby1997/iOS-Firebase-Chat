//
//  AnyCoordinator.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/17.
//

import Combine
import UIKit

protocol AnyCoordinatorProtocol {
    func start()
}

class AnyCoordinatorClass {
    private let sceneIdentifier: UUID
    private (set) var presenter: UIViewController
    
    var children: [UUID: AnyObject] = [:]
    var cancellables: Set<AnyCancellable> = []
    
    weak var parent: AnyCoordinator?
    
    init(sceneIdentifier: UUID = UUID(), presenter: UIViewController, parent: AnyCoordinator? = nil) {
        self.sceneIdentifier = sceneIdentifier
        self.presenter = presenter
        self.parent = parent
    }

    func removeFromParent() {
        self.parent?.removeChild(for: self.sceneIdentifier)
    }
    
    func removeChild(for sceneId: UUID) {
        self.children.removeValue(forKey: sceneId)
    }
}

typealias AnyCoordinator = AnyCoordinatorClass & AnyCoordinatorProtocol
