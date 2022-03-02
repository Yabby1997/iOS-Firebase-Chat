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
        label.text = "당신의 이름은..."
        label.font = .systemFont(ofSize: 30, weight: .bold)
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
    
    private let nextButton: FloatingButton = {
        let button = FloatingButton()
        button.iconImage = UIImage.arrowForward
        button.iconColor = .white
        button.iconInsets = UIEdgeInsets(top: -16, left: 16, bottom: 16, right: -16)
        return button
    }()

    // MARK: - Properties
    
    private var viewModel: AuthenticationViewModel?
    private var cancellables: Set<AnyCancellable> = []
    private lazy var nextButtonBottomConstraint: NSLayoutConstraint = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
    private var keyboardHeight: CGFloat = 0
    @Published var isKeyboardShowing: Bool = false
    
    // MARK: - Initializers
    
    convenience init(viewModel: AuthenticationViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        inputField.resignFirstResponder()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            descriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60)
        ])
        
        view.addSubview(inputField)
        inputField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            inputField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
        ])
        
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: 70),
            nextButton.widthAnchor.constraint(equalToConstant: 70),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            nextButtonBottomConstraint
        ])
    }
    
    private func bindUI() {
        guard let viewModel = viewModel else { return }
        
        inputField.publisher(for: .editingChanged)
            .map { ($0 as? UITextField)?.text ?? "" }
            .assign(to: \.name, on: viewModel)
            .store(in: &cancellables)
        
        nextButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel?.authenticateButtonDidTap()
            }
            .store(in: &cancellables)
        
        viewModel.isAuthenticateButtonEnabledPublisher
            .sink { [weak self] isAuthenticateButtonEnabled in
                self?.nextButton.isEnabled = isAuthenticateButtonEnabled
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification, object: nil)
            .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height }
            .sink { [weak self] height in
                self?.keyboardHeight = height
                self?.isKeyboardShowing = true
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification, object: nil)
            .sink { [weak self] _ in
                self?.isKeyboardShowing = false
            }
            .store(in: &cancellables)
        
        $isKeyboardShowing
            .removeDuplicates()
            .sink { [weak self] isShowing in
                print(isShowing)
                self?.updateKeyboardHeight(isKeyboardShowing: isShowing)
            }
            .store(in: &cancellables)
        
        view.publisher(for: UITapGestureRecognizer())
            .sink { [weak self] _ in
                self?.inputField.resignFirstResponder()
            }
            .store(in: &cancellables)
    }
    
    func updateKeyboardHeight(isKeyboardShowing: Bool) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
            self.nextButtonBottomConstraint.constant -= isKeyboardShowing ? self.keyboardHeight : -self.keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
}

