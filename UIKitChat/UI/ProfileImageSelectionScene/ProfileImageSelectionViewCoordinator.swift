//
//  ProfileImageSelectionViewCoordinator.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/03/01.
//

import UIKit
import PhotosUI

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
        
        viewModel.presentPhotoPickerSignalPublisher
            .sink { [weak self] _ in
                self?.presentPhotoPicker(on: viewController, delegater: viewController)
            }
            .store(in: &cancellables)
    }
    
    private func presentPhotoPicker(on viewController: UIViewController, delegater: PHPickerViewControllerDelegate) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = delegater
        viewController.present(pickerViewController, animated: true)
    }
}
