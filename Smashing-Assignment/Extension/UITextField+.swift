//
//  UITextField+.swift
//  NewCombine
//
//  Created by JIN on 12/26/25.
//

import Combine
import UIKit

extension UITextField {
    func textDidChangePublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { _ in self.text ?? "" }
            .eraseToAnyPublisher()
    }
}


