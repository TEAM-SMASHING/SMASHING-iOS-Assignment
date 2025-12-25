//
//  ViewController.swift
//  Smashing-Assignment
//
//  Created by 이승준 on 12/24/25.
//

import UIKit
import Combine

class JinJaeViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()

    let homeView = HomeView()
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        bind()
    }
    
    private func bind() {
     homeView.textField.textDidChangePublisher()
        .map { $0.count >= 5 }
        .sink { [weak self] isValid in
            guard let self else { return }
            self.homeView.submitButton.isEnabled = isValid
            self.homeView.submitButton.backgroundColor = isValid ? .systemBlue : .lightGray
         }
        .store(in: &cancellables)
    }

}

