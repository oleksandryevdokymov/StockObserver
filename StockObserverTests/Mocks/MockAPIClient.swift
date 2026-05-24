//
//  MockAPIClient.swift
//  StockObserverTests
//
//  Created by Oleksandr Yevdokymov on 24.05.2026.
//

import Foundation
@testable import StockObserver

final class MockAPIClient: APIClient {
    var result: Any?
    var error: Error?

    private(set) var requestedEndpoints: [APIEndpoint] = []

    init(result: Any? = nil,
        error: Error? = nil) {
        self.result = result
        self.error = error
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint, as type: T.Type) async throws -> T {
        requestedEndpoints.append(endpoint)

        if let error {
            throw error
        }

        guard let typedResult = result as? T else {
            throw APIError.invalidResponse
        }

        return typedResult
    }
}
