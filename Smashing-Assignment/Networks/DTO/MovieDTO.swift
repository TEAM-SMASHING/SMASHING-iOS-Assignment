//
//  MovieDTO.swift
//  Smashing-Assignment
//
//  Created by 이승준 on 12/30/25.
//

import Foundation

struct MovieListResponse: Codable {
    let movieListResult: MovieListResult
}

struct MovieListResult: Codable {
    let totCnt: Int
    let source: String
    let movieList: [MovieDTO]
}

struct MovieDTO: Codable {
    let movieCd: String
    let movieNm: String
    let movieNmEn: String?
    let prdtYear: String
    let openDt: String
    let typeNm: String
    let prdtStatNm: String
    let nationAlt: String
    let genreAlt: String
    let repNationNm: String
    let repGenreNm: String
    let directors: [DirectorDTO]
    let companys: [CompanyDTO]
}

struct DirectorDTO: Codable {
    let peopleNm: String
}

struct CompanyDTO: Codable {
    let companyCd: String
    let companyNm: String
}
