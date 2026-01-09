//
//  SearcMovieViewController.swift
//  Smashing-Assignment
//
//  Created by 홍준범 on 1/8/26.
//

import Foundation
import UIKit
import Combine

final class SearchPeopleViewController: UIViewController {
    
    private let viewModel: SearchPeopleViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private let searchView = SearchView()
    
    private let input = PassthroughSubject<SearchPeopleViewModel.Input, Never>()
    
    init(viewModel: SearchPeopleViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchView.setCollectionViewLayout()
    }
    
    private func setupCollectionView() {
        searchView.collectionView.dataSource = self
//        searchView.collectionView.delegate = self
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        bindOutput(output)
        bindInput()
    }
    
    private func bindOutput(_ output: SearchPeopleViewModel.Output ) {
        output.people
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.searchView.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        output.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                print("")
            }
            .store(in: &cancellables)
        
        output.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                print("")
            }
            .store(in: &cancellables)
    }
    
    private func bindInput() {
        searchView.searchBar.textDidChangePublisher()
            .sink { [weak self] text in
                self?.input.send(.searchTextChanged(text))
            }
            .store(in: &cancellables)
        
        searchView.collectionView.reachedBottomPublisher
            .sink { [weak self] _ in
                self?.input.send(.scrollReachedBottom)
            }
            .store(in: &cancellables)
    }
    
}

extension SearchPeopleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfPeople
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchPeopleCollectionViewCell.identifier, for: indexPath) as? SearchPeopleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let person = viewModel.person(at: indexPath.item) else {
            return cell
        }
        
        cell.configure(data: person, index: indexPath.item)
        return cell
    }
}

//extension SearchPeopleViewController: UICollectionViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let height = scrollView.frame.size.height
//        
//        if offsetY > contentHeight - height - 100 {
//            print("스크롤 하단")
//            input.send(.scrollReachedBottom)
//        }
//    }
//}

extension UIScrollView {
    var reachedBottomPublisher: AnyPublisher<Void, Never> {
        return publisher(for: \.contentOffset)
            .map { [weak self] contentOffset -> Bool in
                guard let self = self else { return false }
                
                let offsetY = contentOffset.y
                let contentHeight = self.contentSize.height
                let height = self.frame.size.height
                
                return offsetY > contentHeight - height - 100
            }
            .removeDuplicates()
            .filter { $0 }
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
