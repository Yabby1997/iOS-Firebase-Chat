//
//  ProfileImageSelectionViewController.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/03/01.
//

import Combine
import UIKit

final class ProfileImageSelectionViewController: UIViewController {
    
    // MARK: - Subviews
    
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
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
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
    }
}
