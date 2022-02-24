//
//  DataCache.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/24.
//

import Combine
import Foundation

class DataCache {
    
    static let shared: DataCache = DataCache()
    
    private let downloadNetworkService: DownloadNetworkServiceProtocol = DownloadNetworkService(urlSession: URLSession.shared)
    private var cache = NSCache<NSString, NSData>()
    private var cancellables: Set<AnyCancellable> = []
    
    private init() { }
    
    func fetch(url: URL) -> AnyPublisher<Data, Error> {
        let cacheKey = NSString(string: url.absoluteString)
        
        if let chachedData = self.cache.object(forKey: cacheKey) {
            return Just(Data(referencing: chachedData)).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        return Future<Data, Error> { [weak self] promise in
            guard let self = self else { return }
            self.downloadNetworkService.download(url: url)
                .sink { completion in
                    guard case .failure(let error) = completion else { return }
                    return promise(.failure(error))
                } receiveValue: { [weak self] progress in
                    guard case .complete(let data) = progress else { return }
                    let cacheData = NSData(data: data)
                    self?.cache.setObject(cacheData, forKey: cacheKey)
                    return promise(.success(data))
                }
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
}
