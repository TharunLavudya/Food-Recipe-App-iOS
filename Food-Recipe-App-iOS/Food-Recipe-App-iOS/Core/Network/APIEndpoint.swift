//
//  APIEndpoint.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 2/6/26.
//

import Foundation

protocol APIEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension APIEndpoint {

    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path = path
        components?.queryItems = queryItems.isEmpty ? nil : queryItems
        return components?.url
    }
}
