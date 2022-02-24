//
//  FirebaseNetworkServiceProtocol.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/21.
//

import Combine
import Foundation

protocol FirebaseNetworkServiceProtocol {
    func getDocument(collection: FirebaseCollection, document: String) -> AnyPublisher<[String: Any], Error>
    func setDocument(collection: FirebaseCollection, document: String, dictionary: [String: Any]) -> AnyPublisher<Void, Error>
    func getDocument<T: DataTransferable>(collection: FirebaseCollection, document: String) -> AnyPublisher<T, Error>
    func setDocument<T: DataTransferable>(collection: FirebaseCollection, document: String, transferable: T) -> AnyPublisher<Void, Error>
    func uploadData(path: FirestorePath, data: Data) -> AnyPublisher<URL, Error>
}

protocol DataTransferable {
    init?(dictionary: [String: Any])
    var dictionary: [String: Any] { get }
}

enum FirebaseCollection: String {
    case chattingUser = "chattingUser"
}

enum FirestorePath: String {
    case profileImage = "profileImage"
}
