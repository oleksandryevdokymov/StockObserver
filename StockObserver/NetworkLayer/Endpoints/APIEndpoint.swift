//
//  APIEndpoint.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum APIEndpoint {
    case marketSummary(region: MarketRegion)
    case stockSummary(symbol: String, region: MarketRegion)

    var method: HTTPMethod {
        .get
    }

    var path: String {
        switch self {
        case .marketSummary:
            return "market/v2/get-summary"
        case .stockSummary:
            return "stock/v2/get-summary"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .marketSummary(let region):
            return [
                URLQueryItem(name: "region", value: region.rawValue)
            ]

        case .stockSummary(let symbol, let region):
            return [
                URLQueryItem(name: "symbol", value: symbol),
                URLQueryItem(name: "region", value: region.rawValue)
            ]
        }
    }

    func makeURLRequest() throws -> URLRequest {
        let url = AppConfig.baseURL.appendingPathComponent(path)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }

        components.queryItems = queryItems

        guard let finalURL = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30

        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(AppConfig.rapidAPIKey, forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue(AppConfig.rapidAPIHost, forHTTPHeaderField: "X-RapidAPI-Host")

        return request
    }
}
