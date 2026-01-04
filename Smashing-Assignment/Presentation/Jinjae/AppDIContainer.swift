//
//  AppDIContainer.swift
//  Smashing-Assignment
//
//  Created by JIN on 1/4/26.
//

import UIKit

class AppDIContainer {
    static var shared: AppDIContainer = AppDIContainer()
    
    func makeMainViewController() -> UIViewController {
        let viewModel = HomeViewModel()
        return JinJaeViewController(viewModel: viewModel)
    }
    
}
