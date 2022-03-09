//
//  CircularImageView.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/03/02.
//

import UIKit

final class ProfileImageView: UIImageView {
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = .anonymous
        self.configureUI()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        self.configureUI()
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.image = .anonymous
        self.configureUI()
    }
    
    // MARK: - Callbacks
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2.0
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        clipsToBounds = true
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFill
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: heightAnchor),
            heightAnchor.constraint(equalTo: widthAnchor)
        ])
    }
}
