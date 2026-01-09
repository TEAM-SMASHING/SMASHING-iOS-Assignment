//
//  PersonAPI.swift
//  Smashing-Assignment
//
//  Created by 이승준 on 12/30/25.
//

import Foundation
import Moya
import Alamofire

enum PeopleAPI {
    case fetchPeople(name: String, page: Int)
}

extension PeopleAPI: BaseTargetType {
    
    var path: String {
        switch self {
        case .fetchPeople:
            return "people/searchPeopleList.json"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .fetchPeople(let name, let page):
            return .requestParameters(
                parameters: ["key": Environment.movie_API_Key,
                             "peopleNm": name,
                             "curPage": page,
                             "itemPerPage": 10],
                encoding: URLEncoding.default)
        }
    }
}
