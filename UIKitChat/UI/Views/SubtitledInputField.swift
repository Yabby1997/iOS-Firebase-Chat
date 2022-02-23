//
//  SubtitledInputField.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/20.
//

import UIKit

final class SubtitledInputField: UITextField {
    
    // MARK: - Subviews
    
    private let underBar: UIView = UIView()
    private let subtitleLabel: UILabel = UILabel()
    
    private let textTransition: CATransition = {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.subtype = CATransitionSubtype.fromTop
        return transition
    }()
    
    private lazy var vibratingAnimation: CABasicAnimation = {
        let animation = CABasicAnimation()
        animation.duration = 0.05
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 10, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 10, y: center.y))
        return animation
    }()
    
    // MARK: - Properties

    internal var animationDuration: TimeInterval {
        get { return textTransition.duration }
        set { textTransition.duration = newValue }
    }
    
    internal var vibratingAnimationDuration: TimeInterval {
        get { return vibratingAnimation.duration }
        set { vibratingAnimation.duration = newValue }
    }
    
    internal var vibratingAnimationRepeatCount: Float {
        get { return vibratingAnimation.repeatCount }
        set { vibratingAnimation.repeatCount = newValue }
    }
    
    internal var subtitleLabelTextColor: UIColor? {
        get { return subtitleLabel.textColor }
        set { subtitleLabel.textColor = newValue }
    }
    
    internal var subtitleLabelFont: UIFont? {
        get { return subtitleLabel.font }
        set { subtitleLabel.font = newValue }
    }
    
    internal var barColor: UIColor? {
        didSet { changeUnderBarColor(with: barColor) }
    }
    
    internal var subtitle: String? {
        didSet { changeSubtitleText(with: subtitle) }
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
    
    // MARK: - Helpers
    
    private func configureUI() {
        font = .systemFont(ofSize: 25, weight: .bold)
        
        addSubview(underBar)
        underBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            underBar.heightAnchor.constraint(equalToConstant: 2),
            underBar.topAnchor.constraint(equalTo: bottomAnchor, constant: 8),
            underBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            underBar.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: underBar.topAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    private func changeUnderBarColor(with color: UIColor?) {
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
            self.underBar.backgroundColor = self.barColor
        }
    }
    
    private func changeSubtitleText(with text: String?) {
        subtitleLabel.text = text
        subtitleLabel.layer.add(textTransition, forKey: CATransitionType.fade.rawValue)
    }
    
    // MARK: - Internal Methods
    
    internal func setVibratingAnimationOffset(with offset: CGFloat) {
        vibratingAnimation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - offset, y: center.y))
        vibratingAnimation.toValue = NSValue(cgPoint: CGPoint(x: center.x + offset, y: center.y))
    }
    
    internal func vibrate() {
        layer.add(vibratingAnimation, forKey: "position")
    }
}
