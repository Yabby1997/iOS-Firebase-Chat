//
//  FloatingButton.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/27.
//

import UIKit

final class FloatingButton: UIButton {
    
    // MARK: - Subviews
    
    private let buttonIcon: UIImageView = UIImageView()
    
    // MARK: - Properties
    
    override var isEnabled: Bool {
        didSet { updateBackgroundColor() }
    }
    
    internal var enabledColor: UIColor = .systemGreen
    internal var disabledColor: UIColor = .systemGray
    
    internal var animationDuration: TimeInterval = 0.5
    
    internal var iconImage: UIImage? {
        didSet { buttonIcon.image = iconImage }
    }
    
    internal var iconColor: UIColor? {
        didSet { buttonIcon.tintColor = iconColor }
    }
    
    internal var iconInsets: UIEdgeInsets? {
        didSet { updateIconInsets() }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    // MARK: - Callbacks
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2.0
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        updateBackgroundColor()
        
        addSubview(buttonIcon)
        buttonIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonIcon.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func updateIconInsets() {
        guard let insets = iconInsets else { return }
        NSLayoutConstraint.activate([
            buttonIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left),
            buttonIcon.rightAnchor.constraint(equalTo: rightAnchor, constant: insets.right),
            buttonIcon.topAnchor.constraint(equalTo: topAnchor, constant: insets.bottom),
            buttonIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.top)
        ])
    }
    
    private func updateBackgroundColor() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.backgroundColor = self.isEnabled ? self.enabledColor : self.disabledColor
        }
    }
}
