//
//  APIClient.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import Foundation

protocol APIClient {
    func request<T: Decodable>(_ endpoint: APIEndpoint, as type: T.Type) async throws -> T
}

final class URLSessionAPIClient: APIClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint, as type: T.Type) async throws -> T {
        let request: URLRequest

        do {
            request = try endpoint.makeURLRequest()
        } catch {
            throw APIError.invalidURL
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.transport(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 204:
            throw APIError.noContent
        case 200..<300:
            guard !data.isEmpty else {
                throw APIError.emptyResponse
            }

            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decoding(error)
            }
        case 401:
            throw APIError.unauthorized
        case 403:
            throw APIError.forbidden
        case 429:
            throw APIError.rateLimited
        case 500..<600:
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
}
