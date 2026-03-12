//
//  HttpNetworking.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 2/6/26.
//

import Foundation

final class HttpNetworking: Networking {

    func request<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type
    ) async throws -> T {

        guard let url = endpoint.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)

        request.setValue(
            "iOS Food Recipe App",
            forHTTPHeaderField: "User-Agent"
        )

        let (data, response) =
        try await URLSession.shared.data(for: request)

        guard let httpResponse =
                response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
