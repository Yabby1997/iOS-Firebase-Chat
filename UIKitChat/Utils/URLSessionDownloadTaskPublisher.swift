//
//  URLSessionDownloadTaskPublisher.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/24.
//

import Combine
import Foundation

extension URLSession {
    class DownloadTaskSubscription<S: Subscriber>: Subscription where S.Input == DownloadProgress, S.Failure == Error {
        private var subscriber: S?
        private var task: URLSessionDownloadTask?
        var cancellables: Set<AnyCancellable> = []
        
        init(subscriber: S, task: URLSessionDownloadTask) {
            self.subscriber = subscriber
            self.task = task
        }
        
        func request(_ demand: Subscribers.Demand) { }
        
        func cancel() {
            self.subscriber = nil
            self.task?.cancel()
            self.cancellables.removeAll()
        }
    }
    
    struct DownloadTaskPublisher: Publisher {
        typealias Output = DownloadProgress
        typealias Failure = Error
        
        private let session: URLSession
        private let request: URLRequest
        private var cancellables: Set<AnyCancellable> = []
        
        init(session: URLSession, request: URLRequest) {
            self.session = session
            self.request = request
        }
        
        func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Error, S.Input == DownloadProgress {
            let task = session.downloadTask(with: request) { url, response, error in
                if let error = error { return subscriber.receive(completion: .failure(error)) }
                guard let httpResponse = response as? HTTPURLResponse else { return subscriber.receive(completion: .failure(URLError(.cannotParseResponse))) }
                guard 200..<300 ~= httpResponse.statusCode else { return subscriber.receive(completion: .failure(URLError(.badServerResponse))) }
                guard let url = url else { return subscriber.receive(completion: .failure(URLError(.fileDoesNotExist))) }

                do {
                    let data = try Data(contentsOf: url)
                    let _ = subscriber.receive(.complete(data))
                    subscriber.receive(completion: .finished)
                } catch {
                    subscriber.receive(completion: .failure(error))
                    return
                }
            }
            
            let subscription = DownloadTaskSubscription(subscriber: subscriber, task: task)
            subscriber.receive(subscription: subscription)
            
            task.resume()
            Publishers.CombineLatest(
                task.publisher(for: \.countOfBytesReceived),
                task.publisher(for: \.countOfBytesExpectedToReceive, options: [.initial, .new])
            )
                .sink {
                    let _ = subscriber.receive(.progressing($0.0, $0.1))
                }
                .store(in: &subscription.cancellables)
        }
    }
    
    func downloadTaskPublisher(for request: URLRequest) -> DownloadTaskPublisher {
        return DownloadTaskPublisher(session: self, request: request)
    }
}
