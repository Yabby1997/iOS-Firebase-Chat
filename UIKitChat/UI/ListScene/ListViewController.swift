//
//  ListViewController.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/17.
//

import Combine
import UIKit

final class ListViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: ListViewModelProtocol?
    
    convenience init(viewModel: ListViewModelProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }
    
    private func configureUI() {
        view.backgroundColor = .yellow
    }
    
    private func bindUI() {
    }
}
