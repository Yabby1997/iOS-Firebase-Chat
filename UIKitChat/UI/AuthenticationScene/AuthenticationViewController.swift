//
//  AuthenticationViewController.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/17.
//

import Combine
import UIKit

final class AuthenticationViewController: UIViewController {
    
    // MARK: - Subviews
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "표시될 이름을 입력해주세요."
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let inputField: SubtitledInputField = {
        let subtitledInputField = SubtitledInputField()
        subtitledInputField.barColor = .label
        subtitledInputField.subtitleLabelTextColor = .label
        subtitledInputField.subtitleLabelFont = .systemFont(ofSize: 16, weight: .bold)
        subtitledInputField.textAlignment = .center
        return subtitledInputField
    }()

    // MARK: - Properties
    
    private var viewModel: AuthenticationViewModel?
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializers
    
    convenience init(viewModel: AuthenticationViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.inputField.barColor = .red
            self.inputField.subtitle = "안되는 경우 테스트"
            self.inputField.vibrate()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.inputField.barColor = .systemGreen
            self.inputField.subtitle = "잘 되는 경우 테스트"
        }
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(inputField)
        inputField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            inputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            inputField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
        ])
    }
    
    private func bindUI() {
        guard let viewModel = viewModel else { return }
        
        inputField.publisher(for: .editingChanged)
            .map { ($0 as? UITextField)?.text ?? "" }
            .assign(to: \.name, on: viewModel)
            .store(in: &self.cancellables)
    }
}

