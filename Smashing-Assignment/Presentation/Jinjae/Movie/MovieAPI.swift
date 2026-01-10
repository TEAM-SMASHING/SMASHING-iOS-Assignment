//
//  MovieAPI.swift
//  Smashing-Assignment
//
//  Created by JIN on 1/10/26.
//

import Foundation
import Alamofire
import Moya

enum MovieAPI {
    case searchMovieList(movieNm: String, curPage: Int, itemPerPage: Int)
}

extension MovieAPI: BaseTargetType {
    
    var path: String {
        switch self {
        case .searchMovieList:
            return "movie/searchMovieList.json"
        }
    }

    var method: Moya.Method {
        switch self {
        case .searchMovieList:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .searchMovieList(let movieNm, let curPage, let itemPerPage):
            let parameters: [String: Any] = [
                "key": Environment.movie_API_Key,
                "movieNm": movieNm,
                "curPage": curPage,
                "itemPerPage": itemPerPage
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
}
