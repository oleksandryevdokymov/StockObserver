//
//  APIError.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case noContent
    case emptyResponse
    case unauthorized
    case forbidden
    case rateLimited
    case serverError(statusCode: Int)
    case unexpectedStatusCode(Int)
    case decoding(Error)
    case transport(Error)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .noContent:
            return "The server returned no content."
        case .emptyResponse:
            return "The response body is empty."
        case .unauthorized:
            return "Unauthorized request. Please check the API key."
        case .forbidden:
            return "Forbidden request. Please check your RapidAPI subscription."
        case .rateLimited:
            return "API rate limit exceeded."
        case .serverError(let statusCode):
            return "Server error. Status code: \(statusCode)."
        case .unexpectedStatusCode(let statusCode):
            return "Unexpected status code: \(statusCode)."
        case .decoding(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .transport(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
