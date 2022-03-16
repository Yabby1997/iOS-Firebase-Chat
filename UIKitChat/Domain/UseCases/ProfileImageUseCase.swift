//
//  ProfileImageUseCase.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/03/16.
//

import Combine
import Foundation

final class ProfileImageUseCase: ProfileImageUseCaseProtocol {
    private let firebaseNetworkService: FirebaseNetworkServiceProtocol
    
    init(fireBaseNetworkSerice: FirebaseNetworkServiceProtocol) {
        self.firebaseNetworkService = fireBaseNetworkSerice
    }
    
    func uploadProfileImage(image: Data) -> AnyPublisher<URL, Error> {
        return firebaseNetworkService.uploadData(path: .profileImage, data: image)
    }
}
