//
//  DownloadNetworService.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/24.
//

import Combine
import Foundation

class DownloadNetworkService: DownloadNetworkServiceProtocol {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func download(url: URL) -> AnyPublisher<DownloadProgress, Error> {
        return urlSession.downloadTaskPublisher(for: URLRequest(url: url)).eraseToAnyPublisher()
    }
}
