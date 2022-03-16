//
//  ProfileImageUseCaseProtocol.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/03/16.
//

import Combine
import Foundation

protocol ProfileImageUseCaseProtocol {
    func uploadProfileImage(image: Data) -> AnyPublisher<URL, Error>
}
