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
        setupActions()
        bind()
    }

    // MARK: - Setup Actions

    private func setupActions() {
        homeView.textField.addTarget(self, action: #selector(textField1DidChange), for: .editingChanged)
        homeView.textField2.addTarget(self, action: #selector(textField2DidChange), for: .editingChanged)
        homeView.submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }

    @objc private func textField1DidChange() {
        let text = homeView.textField.text ?? ""
        input.send(.textFieldChanged(text))
    }

    @objc private func textField2DidChange() {
        let text = homeView.textField2.text ?? ""
        input.send(.textField2Changed(text))
    }

    @objc private func submitButtonTapped() {
        input.send(.submitButtonTapped)
    }

    // MARK: - Bind

    private func bind() {
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
