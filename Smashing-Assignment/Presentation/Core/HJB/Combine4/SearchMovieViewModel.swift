//
//  SearchMovieViewModel.swift
//  Smashing-Assignment
//
//  Created by 홍준범 on 1/8/26.
//

import Foundation
import Combine

protocol InputOutputProtocol {

    associatedtype Input
    associatedtype Output
    
    func transform(input: AnyPublisher<Input, Never>) -> Output

}
//
//protocol SearchPeopleViewModelProtocol {
//    associatedtype Input
//    associatedtype Output
//    
//    func transform(input: AnyPublisher<Input, Never>) -> Output
//    
//    var people: [PeopleDTO] { get }
//    var numberOfPeople: Int { get }
//    func person(at index: Int) -> PeopleDTO?
//    
//}

protocol SearchPeopleViewModelProtocol: InputOutputProtocol where Input == SearchPeopleViewModel.Input, Output == SearchPeopleViewModel.Output {
    var people: [PeopleDTO] { get }
    var numberOfPeople: Int { get }
    func person(at index: Int) -> PeopleDTO?
}

class SearchPeopleViewModel: SearchPeopleViewModelProtocol {
    
    enum Input {
        case searchTextChanged(String)
        case scrollReachedBottom
    }
    
    struct Output {
        let people = PassthroughSubject<[PeopleDTO], Never>.init()
        let error = PassthroughSubject<Error, Never>.init()
        let isLoading = CurrentValueSubject<Bool, Never>.init(false)
    }
    
//    struct Output {
//            let people: PassthroughSubject<[PeopleDTO], Never>
//            let error: PassthroughSubject<Error, Never>
//            let isLoading: CurrentValueSubject<Bool, Never>
//        }
//    
//    private let output = Output(
//           people: PassthroughSubject(),
//           error: PassthroughSubject(),
//           isLoading: CurrentValueSubject(false)
//       )
//       
//    private let outputPublisher = PassthroughSubject<Output, Never>()
    
    var people: [PeopleDTO] {
        return peopleList
    }
    
    var numberOfPeople: Int {
        return peopleList.count
    }
    
    func person(at index: Int) -> PeopleDTO? {
        guard index < peopleList.count else { return nil }
        return peopleList[index]
    }
    
   private let output = Output()
//    private let outputPublisher = PassthroughSubject<Output, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    private var peopleList: [PeopleDTO] = []
    
    private var currentSearchText = ""
    private var currentPage = 1
    private var isPeopleFetching = false
    
    func transform(input: AnyPublisher<Input, Never>) -> Output {
    
        input
            .filter { if case .searchTextChanged = $0 { return true }
            return false }
            .compactMap { if case .searchTextChanged(let text) = $0 { return text }
            return nil
            }
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.handleSearchTextChanged(searchText)
            }
            .store(in: &cancellables)
        
        input
            .filter { if case .scrollReachedBottom = $0 { return true }; return false }
            .throttle(for: .seconds(0.3), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] _ in
                self?.handleScrollReachedBottom()
            }
            .store(in: &cancellables)
        
        return output
    }
    
    private func handleSearchTextChanged(_ text: String) {
        currentSearchText = text
        currentPage = 1
        peopleList.removeAll()
        
        guard !text.isEmpty else {
            output.people.send([])
            return
        }
        
        fetchPeople()
    }
    
    private func handleScrollReachedBottom() {
        print("서버 호출")
        fetchPeople()
    }
    
    private func fetchPeople() {
        guard !isPeopleFetching else { return }
        guard !currentSearchText.isEmpty else { return }
        
        isPeopleFetching = true
        output.isLoading.send(true)
        
        NetworkProvider<PeopleAPI>
            .request(.fetchPeople(name: currentSearchText, page: currentPage), type: PeopleListResponse.self) { [weak self] result in
                guard let self = self else { return }
                
                self.isPeopleFetching = false
                output.isLoading.send(false)
                
                switch result {
                case .success(let response):
                    self.peopleList.append(contentsOf: response.peopleListResult.peopleList)
                    output.people.send(self.peopleList)
                    self.currentPage += 1
                    
                case .failure(let error):
                    output.error.send(error)
                }
            }
    }
}
