//
//  UITextField+.swift
//  Smashing-Assignment
//
//  Created by 홍준범 on 12/26/25.
//

import UIKit
import Combine

extension UITextField {
    func textDidChangePublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { _ in self.text ?? "" }
            .eraseToAnyPublisher()
    }
}

extension UITextField {
    func addLeftPadding(_ width: CGFloat = 10) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addRightPadding(_ width: CGFloat = 10) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
    
        /// 텍스트 필드에 좌우 패딩을 한 번에 추가합니다.
    func addPadding(leftAmount: CGFloat = 10, rightAmount: CGFloat = 10) {
        addLeftPadding(leftAmount)
        addRightPadding(rightAmount)
    }
}
