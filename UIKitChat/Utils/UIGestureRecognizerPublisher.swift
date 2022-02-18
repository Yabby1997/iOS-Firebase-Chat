//
//  UIGestureRecognizerPublisher.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/17.
//

import Combine
import UIKit

extension UIGestureRecognizer {
    class GestureSubscription<S: Subscriber>: Subscription where S.Input == UIGestureRecognizer {
        private var subscriber: S?
        
        init(subscriber: S) {
            self.subscriber = subscriber
        }
        
        func request(_ demand: Subscribers.Demand) { }
        
        func cancel() {
            self.subscriber = nil
        }
        
        @objc func handleEvent(_ gestureRecognizer: UIGestureRecognizer) {
            _ = subscriber?.receive(gestureRecognizer)
        }
    }
    
    struct GesturePublisher: Publisher {
        typealias Output = UIGestureRecognizer
        typealias Failure = Never
        
        let view: UIView
        let gestureRecognizer: UIGestureRecognizer
        
        init(view: UIView, gestureRecognizer: UIGestureRecognizer) {
            self.view = view
            self.gestureRecognizer = gestureRecognizer
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, UIGestureRecognizer == S.Input {
            let subscription = GestureSubscription(subscriber: subscriber)
            self.gestureRecognizer.addTarget(subscription, action: #selector(subscription.handleEvent))
            self.view.addGestureRecognizer(self.gestureRecognizer)
            subscriber.receive(subscription: subscription)
        }
    }
}

extension UIView {
    func publisher(for gestureRecognizer: UIGestureRecognizer) -> UIGestureRecognizer.GesturePublisher {
        return UIGestureRecognizer.GesturePublisher(view: self, gestureRecognizer: gestureRecognizer)
    }
}
