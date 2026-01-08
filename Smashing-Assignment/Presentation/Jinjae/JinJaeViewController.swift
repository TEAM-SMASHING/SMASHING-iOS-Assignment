//
//  ViewController.swift
//  Smashing-Assignment
//
//  Created by 이승준 on 12/24/25.
//

import UIKit
import Combine

class JinJaeViewController: UIViewController {

    private let viewModel: HomeViewModel
    private let input: PassthroughSubject<HomeViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    let homeView = HomeView()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    //MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        setupButtonAction()
        bind()
    }

    // MARK: - Setup Button Action

    private func setupButtonAction() {
        homeView.submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }

    @objc private func submitButtonTapped() {
        input.send(.submitButtonTapped)
    }

    // MARK: - Bind

    private func bind() {
        homeView.textField.textDidChangePublisher()
            .map { HomeViewModel.Input.textFieldChanged($0) }
            .subscribe(input)
            .store(in: &cancellables)

        homeView.textField2.textDidChangePublisher()
            .map { HomeViewModel.Input.textField2Changed($0) }
            .subscribe(input)
            .store(in: &cancellables)

        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }

                switch event {
                case .updateButtonState(let isEnabled):
                    self.homeView.submitButton.isEnabled = isEnabled
                    self.homeView.submitButton.backgroundColor = isEnabled ? .systemBlue : .lightGray
                case .updateMessage(let message):
                    self.homeView.messageLabel.text = message
                case .clearTextFields:
                    self.homeView.textField.text = ""
                    self.homeView.textField2.text = ""
                }
            }
            .store(in: &cancellables)
    }

}
