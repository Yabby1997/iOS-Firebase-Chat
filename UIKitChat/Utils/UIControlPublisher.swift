//
//  UIControlPublisher.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/17.
//

import Combine
import UIKit

extension UIControl {
    class EventSubscription<S: Subscriber>: Subscription where S.Input == UIControl {
        private var subscriber: S?
        
        init(subscriber: S) {
            self.subscriber = subscriber
        }
        
        func request(_ demand: Subscribers.Demand) { }
        
        func cancel() {
            self.subscriber = nil
        }
        
        @objc func handleEvent(_ sender: UIControl) {
            _ = subscriber?.receive(sender)
        }
    }
    
    struct EventPublisher: Publisher {
        typealias Output = UIControl
        typealias Failure = Never
        
        private let control: UIControl
        private let event: UIControl.Event
        
        init(control: UIControl, event: UIControl.Event) {
            self.control = control
            self.event = event
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, UIControl == S.Input {
            let subscription = EventSubscription(subscriber: subscriber)
            self.control.addTarget(subscription, action: #selector(subscription.handleEvent), for: event)
            subscriber.receive(subscription: subscription)
        }
    }
    
    func publisher(for event: UIControl.Event) -> UIControl.EventPublisher {
        return EventPublisher(control: self, event: event)
    }
}
