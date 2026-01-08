//
//  HomeViewModel.swift
//  Smashing-Assignment
//
//  Created by JIN on 12/30/25.
//

import UIKit
import Combine

protocol InputOutputProtocol {

    associatedtype Input
    associatedtype Output

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>

}


final class HomeViewModel: InputOutputProtocol {

    enum Input {
        case textFieldChanged(String)
        case textField2Changed(String)
        case submitButtonTapped
    }

    enum Output {
        case updateButtonState(isEnabled: Bool)
        case updateMessage(String)
        case clearTextFields
    }

    // MARK: - Properties

    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    private let text1Subject = CurrentValueSubject<String, Never>("")
    private let text2Subject = CurrentValueSubject<String, Never>("")

    // MARK: - Transform

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .textFieldChanged(let text):
                self.text1Subject.send(text)

            case .textField2Changed(let text):
                self.text2Subject.send(text)

            case .submitButtonTapped:
                self.handleSubmitButtonTapped()
            }
        }.store(in: &cancellables)

        Publishers.CombineLatest(text1Subject, text2Subject)
            .map { $0.count >= 5 && $1.count >= 5 }
            .removeDuplicates()
            .sink { [weak self] isValid in
                guard let self = self else { return }

                self.output.send(.updateButtonState(isEnabled: isValid))

                if isValid {
                    self.output.send(.updateMessage("입력 완료"))
                } else {
                    self.output.send(.updateMessage("두 필드 모두 5글자 이상 입력해주세요"))
                }
            }
            .store(in: &cancellables)

        return output.eraseToAnyPublisher()
    }

    // MARK: - Private Methods

    private func handleSubmitButtonTapped() {
        text1Subject.send("")
        text2Subject.send("")
        output.send(.clearTextFields)
        output.send(.updateMessage("5글자 이상 입력해주세요"))
    }
}


