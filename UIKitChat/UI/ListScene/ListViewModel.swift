//
//  ListViewModel.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/17.
//

import Combine
import Foundation

protocol ListViewModelProtocol {
    var deinitSignal: PassthroughSubject<Void, Never> { get }
}

final class ListViewModel: ListViewModelProtocol {
    var deinitSignal: PassthroughSubject<Void, Never> = PassthroughSubject()
    
}
