//
//  HomeView.swift
//  NewCombine
//
//  Created by JIN on 12/26/25.
//

import UIKit

import SnapKit
import Then

class HomeView: UIView {

    // MARK: - UI

    let textField = UITextField().then {
        $0.borderStyle = .roundedRect
    }

    let textField2 = UITextField().then {
        $0.borderStyle = .roundedRect
    }

    let messageLabel = UILabel().then {
        $0.text = "5글자 이상 입력해 주세요"
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 0
        $0.textColor = .secondaryLabel
    }
    let submitButton = UIButton(type: .system).then {
        $0.setTitle("clear", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.white.withAlphaComponent(0.6), for: .disabled)
        $0.backgroundColor = .lightGray
        $0.isEnabled = false
        $0.layer.cornerRadius = 8
    }

    // MARK: - Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupLayout()
    }

    // MARK: - SetLayout

    private func setupUI() {
        backgroundColor = .systemBackground
        addSubview(textField)
        addSubview(textField2)
        addSubview(messageLabel)
        addSubview(submitButton)
    }

    private func setupLayout() {
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-30)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }

        textField2.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }

        messageLabel.snp.makeConstraints {
            $0.top.equalTo(textField2.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        submitButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
    }
}
