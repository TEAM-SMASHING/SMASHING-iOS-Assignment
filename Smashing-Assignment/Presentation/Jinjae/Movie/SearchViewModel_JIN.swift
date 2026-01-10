//
//  SearchViewModel_JIN.swift
//  Smashing-Assignment
//
//  Created by JIN on 1/8/26.
//

import UIKit
import Combine

protocol InputOutputStructProtocol {

    associatedtype Input
    associatedtype Output

    func transform(input: AnyPublisher<Input, Never>) -> Output

}

final class SearchViewModel_JIN: InputOutputStructProtocol {

    // MARK: - Input

    enum Input {
        case searchTextChanged(String)
        case loadMoreTriggered
    }

    // MARK: - Output

    struct Output {
        let movies: AnyPublisher<[MovieDTO], Never>
        let isLoading: AnyPublisher<Bool, Never>
        let error: AnyPublisher<String?, Never>
    }

    // MARK: - Properties

    private let moviesSubject = CurrentValueSubject<[MovieDTO], Never>([])
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = CurrentValueSubject<String?, Never>(nil)

    private var cancellables = Set<AnyCancellable>()
    private var currentQuery: String = ""
    private var currentPage: Int = 1

    // MARK: - Transform

    func transform(input: AnyPublisher<Input, Never>) -> Output {

        input
            .compactMap { event -> String? in
                if case .searchTextChanged(let text) = event {
                    return text
                }
                return nil
            }
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.handleSearchTextChanged(text)
            }
            .store(in: &cancellables)
        input
            .filter { event in
                if case .loadMoreTriggered = event {
                    return true
                }
                return false
            }
            .throttle(for: .seconds(0.3), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] _ in
                self?.handleLoadMore()
            }
            .store(in: &cancellables)

        return Output(
            movies: moviesSubject.eraseToAnyPublisher(),
            isLoading: isLoadingSubject.eraseToAnyPublisher(),
            error: errorSubject.eraseToAnyPublisher()
        )
    }
    
    
    // MARK: - Private Methods
    
    private func handleSearchTextChanged(_ text: String) {
        currentQuery = text
        currentPage = 1
        fetchMovies(query: text, page: 1, isNewSearch: true)
    }

    private func handleLoadMore() {
        currentPage += 1
        fetchMovies(query: currentQuery, page: currentPage, isNewSearch: false)
    }
}

// MARK: - API

extension SearchViewModel_JIN {

    private func fetchMovies(query: String, page: Int, isNewSearch: Bool) {
        guard !query.isEmpty else {
            moviesSubject.send([])
            return
        }

        isLoadingSubject.send(true)

        Task {
            do {
                let movies = try await loadMovies(query: query, page: page)
                if isNewSearch {
                    self.moviesSubject.send(movies)
                } else {
                    var currentMovies = self.moviesSubject.value
                    currentMovies.append(contentsOf: movies)
                    self.moviesSubject.send(currentMovies)
                }
                self.isLoadingSubject.send(false)
            } catch {
                self.errorSubject.send("영화 검색 실패: \(error.localizedDescription)")
                self.isLoadingSubject.send(false)
            }
        }
    }

    private func loadMovies(query: String, page: Int) async throws -> [MovieDTO] {
     
         return try await loadMoviesFromAPI(query: query, page: page)

        // Mock 테스트
        // return try await loadMoviesFromMock(query: query, page: page)
    }

    // MARK: - API Call

    private func loadMoviesFromAPI(query: String, page: Int) async throws -> [MovieDTO] {
        return try await withCheckedThrowingContinuation { continuation in
            NetworkProvider<MovieAPI>.request(
                .searchMovieList(movieNm: query, curPage: page, itemPerPage: 10),
                type: MovieListResponse.self
            ) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response.movieListResult.movieList)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    // MARK: - Mock Test

    private func loadMoviesFromMock(query: String, page: Int) async throws -> [MovieDTO] {
      
        try await Task.sleep(nanoseconds: 1_000_000_000)

        return generateDummyMovies(query: query, page: page)
    }

    private func generateDummyMovies(query: String, page: Int) -> [MovieDTO] {
        return (1...10).map { index in
            MovieDTO(
                movieCd: "\((page - 1) * 10 + index)",
                movieNm: "\(query) 영화 \((page - 1) * 10 + index)",
                movieNmEn: "\(query) Movie \((page - 1) * 10 + index)",
                prdtYear: "202\(index % 5)",
                openDt: "2024010\(index % 9 + 1)",
                typeNm: "장편",
                prdtStatNm: "개봉",
                nationAlt: "한국",
                genreAlt: "드라마",
                repNationNm: "한국",
                repGenreNm: "드라마",
                directors: [DirectorDTO(peopleNm: "감독\(index)")],
                companys: [CompanyDTO(companyCd: "C00\(index)", companyNm: "제작사\(index)")]
            )
        }
    }
}
