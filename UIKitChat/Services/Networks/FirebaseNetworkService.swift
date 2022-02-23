//
//  FirebaseNetworkService.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/21.
//

import Combine
import Foundation

import Firebase

class FirebaseNetworkService: FirebaseNetworkServiceProtocol {
    
    enum Errors: LocalizedError {
        case invalidDocumentSnapshot
        case snapshotNotDecodable
        
        var errorDescription: String? {
            switch self {
            case .invalidDocumentSnapshot: return "올바르지 않은 스냅샷입니다."
            case .snapshotNotDecodable: return "스냅샷 디코딩에 실패했습니다."
            }
        }
    }
    
    func getDocument(collection: String, document: String) -> AnyPublisher<[String: Any], Error> {
        return Future { promise in
            Firestore.firestore().collection(collection)
                .document(document)
                .getDocument { snapshot, error in
                    if let error = error { return promise(.failure(error)) }
                    guard let dictionary = snapshot?.data() else { return promise(.failure(Errors.invalidDocumentSnapshot)) }
                    return promise(.success(dictionary))
                }
        }
        .eraseToAnyPublisher()
    }
    
    func getDocument<T: DataTransferable>(collection: String, document: String) -> AnyPublisher<T, Error> {
        return getDocument(collection: collection, document: document)
            .tryMap { dictionary in
                guard let decoded = T(dictionary: dictionary) else { throw Errors.snapshotNotDecodable }
                return decoded
            }
            .eraseToAnyPublisher()
    }
    
    func setDocument(collection: String, document: String, dictionary: [String: Any]) -> AnyPublisher<Void, Error> {
        return Future { promise in
            Firestore.firestore().collection(collection)
                .document(document)
                .setData(dictionary) { error in
                    if let error = error { return promise(.failure(error)) }
                    return promise(.success(()))
                }
        }
        .eraseToAnyPublisher()
    }
    
    func setDocument<T: DataTransferable>(collection: String, document: String, transferable: T) -> AnyPublisher<Void, Error> {
        let dictionary = transferable.dictionary
        return setDocument(collection: collection, document: document, dictionary: dictionary)
    }
}
