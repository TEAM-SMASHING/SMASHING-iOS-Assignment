//
//  AlertViewController.swift
//  Smashing-Assignment
//
//  Created by 이승준 on 12/29/25.
//

import UIKit

final class AlertViewController: UIViewController {
    
    private let jinjaeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("진재 탭으로 이동", for: .normal)
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
        view.addSubview(jinjaeButton)
        
        NSLayoutConstraint.activate([
            jinjaeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            jinjaeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            jinjaeButton.widthAnchor.constraint(equalToConstant: 200),
            jinjaeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 4. 버튼 클릭 액션 연결
        jinjaeButton.addTarget(self, action: #selector(jinjaeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func jinjaeButtonTapped() {
        // 버튼을 누르면 로그인 성공 로직 실행
        goToJinjae()
    }
    
    func goToJinjae() {
        TabBarController.shared?.switchToTab(.jinjae)
        self.navigationController?.popViewController(animated: true)
    }
}
