//
//  PeopleDTO.swift
//  Smashing-Assignment
//
//  Created by 이승준 on 12/30/25.
//

import Foundation

struct PeopleListResponse: Codable {
    let peopleListResult: PeopleListResult
}

struct PeopleListResult: Codable {
    let totCnt: Int
    let source: String
    let peopleList: [PeopleDTO]
}

struct PeopleDTO: Codable {
    let peopleCd: String
    let peopleNm: String
    let peopleNmEn: String
    let repRoleNm: String
    let filmoNames: String
}

