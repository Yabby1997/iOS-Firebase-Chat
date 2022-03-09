//
//  ProfileImageSelectionViewController.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/03/01.
//

import Combine
import UIKit
import PhotosUI

final class ProfileImageSelectionViewController: UIViewController {
    
    // MARK: - Subviews
    
    private let profileImageView: ProfileImageView = ProfileImageView()
    
    private let nextButton: FloatingButton = {
        let button = FloatingButton()
        button.iconImage = UIImage.arrowForward
        button.iconColor = .white
        button.iconInsets = UIEdgeInsets(top: -16, left: 16, bottom: 16, right: -16)
        return button
    }()
    
    // MARK: - Properties
    
    private var viewModel: ProfileImageSelectionViewModelProtocol?
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializers
    
    convenience init(viewModel: ProfileImageSelectionViewModelProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bindViewModel()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: 70),
            nextButton.widthAnchor.constraint(equalToConstant: 70),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
    }
    
    private func bindUI() {
        nextButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel?.uploadButtonDidTap()
            }
            .store(in: &cancellables)
        
        profileImageView.publisher(for: UITapGestureRecognizer())
            .sink { [weak self] _ in
                self?.viewModel?.profileImageDidTap()
            }
            .store(in: &cancellables)
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.profileImagePublisher
            .compactMap { $0 }
            .map { UIImage(data: $0) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.profileImageView.image = image
            }
            .store(in: &cancellables)
    }
}

extension ProfileImageSelectionViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            if let error = error { self?.viewModel?.error = error }
            guard let imageData = (image as? UIImage)?.jpegData(compressionQuality: 0.75) else { return }
            self?.viewModel?.profileImage = imageData
        }
    }
}
