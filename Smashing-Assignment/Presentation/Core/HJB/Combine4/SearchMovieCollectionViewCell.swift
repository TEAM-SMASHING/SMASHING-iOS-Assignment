//
//  SearchMovieCollectionViewCell.swift
//  Smashing-Assignment
//
//  Created by 홍준범 on 1/8/26.
//

import UIKit
import Combine

import SnapKit
import Then

final class SearchPeopleCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "SearchPeopleCollectionViewCell"
    
    private let peopleNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private let roleLabel = UILabel().then {
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .systemGray
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(peopleNameLabel)
        contentView.addSubview(roleLabel)
        
        peopleNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(roleLabel.snp.leading).offset(-10)
        }
        
        roleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(80)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: PeopleDTO, index: Int) {
        // 색상 변경 (10명씩 다른 색)
        switch (index / 10) % 3 {
        case 0:
            peopleNameLabel.textColor = .systemPink
        case 1:
            peopleNameLabel.textColor = .systemCyan
        case 2:
            peopleNameLabel.textColor = .systemGreen
        default:
            peopleNameLabel.textColor = .white
        }
        
        peopleNameLabel.text = "\(index + 1): \(data.peopleNm)"
        roleLabel.text = data.repRoleNm ?? "-"
    }
    
}
