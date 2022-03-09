//
//  CircularImageView.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/03/02.
//

import UIKit

final class CircularImageView: UIImageView {
    
    // MARK: - Callbacks
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2.0
    }
}
