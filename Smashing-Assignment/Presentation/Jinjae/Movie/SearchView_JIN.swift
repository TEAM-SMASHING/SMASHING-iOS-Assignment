//
//  SearchView_JIN.swift
//  Smashing-Assignment
//
//  Created by JIN on 1/8/26.
//

import UIKit
import Combine

import Then
import SnapKit

final class SearchView_JIN: UIView {

    // MARK: - UI Components

    let searchBar = UITextField().then {
        $0.isUserInteractionEnabled = true
        $0.placeholder = "검색어를 입력하세요"
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.white.cgColor
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }

    let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(SearchMovieCollectionViewCell_JIN.self,
                            forCellWithReuseIdentifier: SearchMovieCollectionViewCell_JIN.identifier)
        return collection
    }()

    private let loadingIndicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }

    // MARK: - Properties

    private var movies: [MovieDTO] = []
    private let loadMoreSubject = PassthroughSubject<Void, Never>()

    var loadMorePublisher: AnyPublisher<Void, Never> {
        return loadMoreSubject.eraseToAnyPublisher()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .systemBackground
        addSubview(searchBar)
        addSubview(collectionView)
        addSubview(loadingIndicator)
    }

    private func setupLayout() {
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        let flowLayout = UICollectionViewFlowLayout()
        let cellWidth: CGFloat = UIScreen.main.bounds.width
        flowLayout.itemSize = CGSize(width: cellWidth, height: 100)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }

    // MARK: - Public Methods

    func updateMovies(_ movies: [MovieDTO]) {
        self.movies = movies
        collectionView.reloadData()
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension SearchView_JIN: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchMovieCollectionViewCell_JIN.identifier,
            for: indexPath
        ) as? SearchMovieCollectionViewCell_JIN else {
            return UICollectionViewCell()
        }

        let movie = movies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SearchView_JIN: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height

        if offsetY > contentHeight - scrollViewHeight - 100 {
            loadMoreSubject.send(())
        }
    }
}
