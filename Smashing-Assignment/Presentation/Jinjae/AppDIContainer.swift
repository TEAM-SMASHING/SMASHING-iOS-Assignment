//
//  AppDIContainer.swift
//  Smashing-Assignment
//
//  Created by JIN on 1/4/26.
//

import UIKit

class AppDIContainer {
    static var shared: AppDIContainer = AppDIContainer()

    func makeJInJaeViewController() -> UIViewController {
        let viewModel = HomeViewModel()
        return JinJaeViewController(viewModel: viewModel)
    }

    func makeSearchViewController() -> UIViewController {
        let viewModel = SearchViewModel_JIN()
        return SearchViewController_JIN(viewModel: viewModel)
    }

}
