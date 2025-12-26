//
//  Combine_HJB.swift
//  Smashing-Assignment
//
//  Created by 홍준범 on 12/26/25.
//

import UIKit
import Combine

import Then
import SnapKit


class CombineViewController_HJB: UIViewController {
    @Published var combineText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    private let homeView = CombineView_HJB()
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        addTarget()
    }
    
    private func bind() {
        homeView.combineTextField.textDidChangePublisher()
            .assign(to: &$combineText)
        
        $combineText
            .sink { [weak self] text in
                if text.count >= 5 {
                    self?.homeView.combineButton.isEnabled = true
                    self?.homeView.combineButton.backgroundColor = .systemBlue
                    self?.homeView.infoText.isHidden = true
                    
                } else {
                    self?.homeView.combineButton.isEnabled = false
                    self?.homeView.combineButton.backgroundColor = .gray
                    self?.homeView.infoText.isHidden = false
                }
            }
            .store(in: &cancellables)
    }

    private func addTarget() {
        homeView.combineButton.addTarget(self, action: #selector(combineButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func combineButtonTapped() {
        print("Tapped")
    }
}
