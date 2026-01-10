//
//  SearchViewController_JIN.swift
//  Smashing-Assignment
//
//  Created by JIN on 1/8/26.
//

import UIKit
import Combine

@MainActor
final class SearchViewController_JIN: UIViewController {

    // MARK: - Properties

    private let viewModel: SearchViewModel_JIN
    private let input: PassthroughSubject<SearchViewModel_JIN.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    private let searchView = SearchView_JIN()

    // MARK: - Initializer

    init(viewModel: SearchViewModel_JIN) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = searchView
        setupNavigationBar()
        bind()
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Bind

    private func bind() {
        searchView.searchBar.textDidChangePublisher()
            .map { SearchViewModel_JIN.Input.searchTextChanged($0) }
            .subscribe(input)
            .store(in: &cancellables)

        searchView.loadMorePublisher
            .map { SearchViewModel_JIN.Input.loadMoreTriggered }
            .subscribe(input)
            .store(in: &cancellables)

        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output.movies
            .sink { [weak self] movies in
                self?.searchView.updateMovies(movies)
            }
            .store(in: &cancellables)

        output.isLoading
            .sink { [weak self] isLoading in
                self?.searchView.setLoading(isLoading)
            }
            .store(in: &cancellables)

        output.error
            .compactMap { $0 }
            .sink { [weak self] errorMessage in
                self?.showError(errorMessage)
            }
            .store(in: &cancellables)
    }

    // MARK: - Private Methods

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
