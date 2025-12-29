//
//  AppSceneFactory.swift
//  Smashing-Assignment
//
//  Created by 이승준 on 12/29/25.
//

import UIKit

enum SceneType {
    case login
    case signup
    case main
}

protocol SceneFactory {
    func makeScene(for type: SceneType) -> UIViewController
}

final class AppSceneFactory: SceneFactory {
    func makeScene(for type: SceneType) -> UIViewController {
        switch type {
        case .login:
            let loginVC = LoginViewController()
            return UINavigationController(rootViewController: loginVC)
        case .signup:
            let signUpVC = SignUpViewController()
            return UINavigationController(rootViewController: signUpVC)
        case .main:
            let mainVC = TabBarController()
            return UINavigationController(rootViewController: mainVC)
        }
    }
}
