//
//  LoginViewController.swift
//  Smashing-Assignment
//
//  Created by 이승준 on 12/29/25.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    // 1. 버튼 생성
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인 성공 시뮬레이션", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        // 2. 뷰에 버튼 추가
        view.addSubview(loginButton)
        
        // 3. 레이아웃 설정 (중앙 배치)
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 4. 버튼 클릭 액션 연결
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        // 버튼을 누르면 로그인 성공 로직 실행
        didLoginSuccess()
    }
    
    func didLoginSuccess() {
        let factory = AppSceneFactory()
        let mainScene = factory.makeScene(for: .main)
        RootViewSwitcher.shared.setRoot(mainScene)
    }
}
