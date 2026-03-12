//
//  Networking.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 2/6/26.
//

import Foundation

protocol Networking {

    func request<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type
    ) async throws -> T
}
