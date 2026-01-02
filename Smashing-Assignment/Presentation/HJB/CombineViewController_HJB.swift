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

protocol InputOutputProtocol {

    associatedtype Input
    associatedtype Output
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}

class CombineViewModel_HJB: InputOutputProtocol {
   
    enum Input {
        case firstTextFieldChanged(String)
        case secondTextFieldChanged(String)
        case buttonTapped
    }
    
    enum Output {
        case toggleButton(isEnabled: Bool)
        case clearTextFields
    }
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private let firstTextSubject = CurrentValueSubject<String, Never>("")
    private let secondTextSubject = CurrentValueSubject<String, Never>("")
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .firstTextFieldChanged(let text):
                self?.firstTextSubject.send(text)
            case .secondTextFieldChanged(let text):
                self?.secondTextSubject.send(text)
            case .buttonTapped:
                self?.firstTextSubject.send("")
                self?.secondTextSubject.send("")
                self?.output.send(.clearTextFields)
            }
        }.store(in: &cancellables)
        
        Publishers.CombineLatest(firstTextSubject, secondTextSubject)
            .map { first, second in
                return first.count >= 5 && second.count >= 5
            }
            .sink { [weak self] isEnabled in
                self?.output.send(.toggleButton(isEnabled: isEnabled))
            }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

class CombineViewController_HJB: UIViewController {
    @Published var combineText: String = ""
    
//    private let vm = CombineViewModel_HJB()
    private let vm: CombineViewModel_HJB
    
    private let input: PassthroughSubject<CombineViewModel_HJB.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private let homeView = CombineView_HJB()
    
    init(viewModel: CombineViewModel_HJB) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            .sink { [weak self] text in
                self?.input.send(.firstTextFieldChanged(text))
            }.store(in: &cancellables)
        
        homeView.secondCombineTextField.textDidChangePublisher()
            .sink { [weak self] text in
                self?.input.send(.secondTextFieldChanged(text))
            }.store(in: &cancellables)
        
        let output = vm.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main) //이거 없애서 해보기
            .sink { [weak self] event in
                switch event {
                case .toggleButton(let isEnabled):
                    self?.homeView.combineButton.isEnabled = isEnabled
                    self?.homeView.combineButton.backgroundColor = isEnabled ? .systemBlue : .gray
                case .clearTextFields:
                    self?.homeView.combineTextField.text = ""
                    self?.homeView.secondCombineTextField.text = ""
                }
            }.store(in: &cancellables)
    }

    private func addTarget() {
        homeView.combineButton.addTarget(self, action: #selector(combineButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func combineButtonTapped(_ sender: UIButton) {
        input.send(.buttonTapped)
    }
}

//    private func bind() {
//        homeView.combineTextField.textDidChangePublisher()
//            .assign(to: &$combineText)
//
//        $combineText
//            .sink { [weak self] text in
//                if text.count >= 5 {
//                    self?.homeView.combineButton.isEnabled = true
//                    self?.homeView.combineButton.backgroundColor = .systemBlue
//                    self?.homeView.infoText.isHidden = true
//
//                } else {
//                    self?.homeView.combineButton.isEnabled = false
//                    self?.homeView.combineButton.backgroundColor = .gray
//                    self?.homeView.infoText.isHidden = false
//                }
//            }
//            .store(in: &cancellables)
//    }
