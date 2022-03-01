//
//  ProfileImageSelectionViewModel.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/03/01.
//

import Combine
import Foundation

protocol ProfileImageSelectionViewModelProtocol {
    var deinitSignalPublisher: PassthroughSubject<Void, Never> { get }
    var errorPublisher: AnyPublisher<Error?, Never> { get }
    var profileImage: Data? { get set }
    
    func uploadButtonDidTap()
}

final class ProfileImageSelectionViewModel: ProfileImageSelectionViewModelProtocol {
    var deinitSignalPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    var errorPublisher: AnyPublisher<Error?, Never> { $error.eraseToAnyPublisher() }
    var profileImage: Data? = nil

    @Published private var error: Error? = nil
    
    private var cancellables: Set<AnyCancellable> = []
    
    func uploadButtonDidTap() {
        self.deinitSignalPublisher.send(())
    }
}
