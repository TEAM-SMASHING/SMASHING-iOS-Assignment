//
//  SearchViewModel_JIN.swift
//  Smashing-Assignment
//
//  Created by JIN on 1/8/26.
//

import UIKit

import Combine

class SearchViewModel_JIN: InputOutputProtocol {
    
    enum Input {
        case searchTextChanged(String)
        case loadMoreTriggered
    }
    
    struct Output {
        let movies: AnyPublisher<[MovieDTO], Never>
        let isLoading: AnyPublisher<Bool, Never>
        let error: AnyPublisher<Error, Never>
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        <#code#>
    }
}
