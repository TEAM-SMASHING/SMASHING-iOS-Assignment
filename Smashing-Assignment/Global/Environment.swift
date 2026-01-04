//
//  Environment.swift
//  Smashing-Assignment
//
//  Created by 이승준 on 12/30/25.
//

import Foundation

enum Environment {
    static let baseURL: String = Bundle.main.infoDictionary?["BaseURL"] as! String
    static let movie_API_Key: String = Bundle.main.infoDictionary?["MOVIE_API_KEY"] as! String
}
