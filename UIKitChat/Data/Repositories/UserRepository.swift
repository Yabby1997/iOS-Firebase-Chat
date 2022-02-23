//
//  UserRepository.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/21.
//

import Combine
import Foundation

class UserRepository: UserRepositoryProtocol {
    
    private let firebaseNetworkService: FirebaseNetworkServiceProtocol
    
    init(firebaseNetworkService: FirebaseNetworkServiceProtocol) {
        self.firebaseNetworkService = firebaseNetworkService
    }
    
    func authUser(uid: String, name: String, profileImage: Data?) -> AnyPublisher<Void, Error> {
        let chattingUser = ChattingUser(name: name, profileImage: nil)
        return firebaseNetworkService.setDocument(collection: FirebaseCollection.chattingUser, document: uid, transferable: chattingUser)
    }
    
    func fetchUser(uid: String) -> AnyPublisher<ChattingUser, Error> {
        return firebaseNetworkService.getDocument(collection: FirebaseCollection.chattingUser, document: uid)
    }
}
