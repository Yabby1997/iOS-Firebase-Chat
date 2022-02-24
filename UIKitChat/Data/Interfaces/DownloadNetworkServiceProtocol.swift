//
//  DownloadNetworkServiceProtocol.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/24.
//

import Combine
import Foundation

protocol DownloadNetworkServiceProtocol {
    func download(url: URL) -> AnyPublisher<DownloadProgress, Error>
}

enum DownloadProgress {
    case complete(Data)
    case progressing(Int64, Int64)
}
