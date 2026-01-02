//
//  CombineView_HJB.swift
//  Smashing-Assignment
//
//  Created by 홍준범 on 12/26/25.
//

import UIKit

import Then
import SnapKit

final class CombineView_HJB: UIView {
    var combineTextField = UITextField().then {
        $0.placeholder = "Combine"
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.addPadding()
    }
    
    var secondCombineTextField = UITextField().then {
        $0.placeholder = "Combine2"
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.addPadding()
    }
    
    var infoText = UILabel().then {
        $0.text = "두개의 텍스트 박스에 모두 5글자 이상 입력 시 삭제 가능"
        $0.textAlignment = .center
    }
    
    var combineButton = UIButton().then {
        $0.setTitle("Next", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .gray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(combineTextField)
        addSubview(secondCombineTextField)
        addSubview(infoText)
        addSubview(combineButton)
    }
    
    private func setLayout() {
        combineTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        secondCombineTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(combineTextField.snp.bottom).offset(20)
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        infoText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(secondCombineTextField.snp.bottom).offset(20)
        }
        
        combineButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(infoText.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(40)
        }
    }
}
