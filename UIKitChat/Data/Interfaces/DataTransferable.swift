//
//  DataTransferable.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/21.
//

import Foundation

protocol DataTransferable {
    init?(dictionary: [String: Any])
    var dictionary: [String: Any] { get }
}
