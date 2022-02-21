//
//  FirebaseNetworkServiceProtocol.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/21.
//

import Combine
import Foundation

protocol FirebaseNetworkServiceProtocol {
    func getDocument(collection: String, document: String) -> AnyPublisher<[String: Any], Error>
    func setDocument(collection: String, document: String, dictionary: [String: Any]) -> AnyPublisher<Void, Error>
    func getDocument<T: DataTransferable>(collection: String, document: String) -> AnyPublisher<T, Error>
    func setDocument<T: DataTransferable>(collection: String, document: String, transferable: T) -> AnyPublisher<Void, Error>
}
