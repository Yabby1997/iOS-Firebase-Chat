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
    var presentPhotoPickerSignalPublisher: PassthroughSubject<Void, Never> { get }
    var errorPublisher: AnyPublisher<Error?, Never> { get }
    var profileImagePublisher: AnyPublisher<Data?, Never> { get }
    var error: Error? { get set }
    var profileImage: Data? { get set }
    
    func uploadButtonDidTap()
    func profileImageDidTap()
}

final class ProfileImageSelectionViewModel: ProfileImageSelectionViewModelProtocol {
    var deinitSignalPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    var presentPhotoPickerSignalPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    var errorPublisher: AnyPublisher<Error?, Never> { $error.eraseToAnyPublisher() }
    var profileImagePublisher: AnyPublisher<Data?, Never> { $profileImage.eraseToAnyPublisher() }

    @Published var error: Error? = nil
    @Published var profileImage: Data? = nil
    
    private var cancellables: Set<AnyCancellable> = []
    
    func uploadButtonDidTap() {
        self.deinitSignalPublisher.send(())
    }
    
    func profileImageDidTap() {
        self.presentPhotoPickerSignalPublisher.send(())
    }
}
