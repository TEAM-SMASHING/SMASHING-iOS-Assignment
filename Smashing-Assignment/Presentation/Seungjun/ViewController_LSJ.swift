//
//  ViewController_LSJ.swift
//  Smashing-Assignment
//
//  Created by 이승준 on 12/26/25.
//

import UIKit

final class ViewController_LSJ: UIViewController {
    
    private let alertButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("알림 창 이동", for: .normal)
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
        view.addSubview(alertButton)
        
        NSLayoutConstraint.activate([
            alertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertButton.widthAnchor.constraint(equalToConstant: 200),
            alertButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 4. 버튼 클릭 액션 연결
        alertButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        // 버튼을 누르면 로그인 성공 로직 실행
        goToAlert()
    }
    
    func goToAlert() {
        self.navigationController?.pushViewController(AlertViewController(), animated: true)
    }
}
