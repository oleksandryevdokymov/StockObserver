//
//  YahooFinanceMarketService.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import Foundation

final class YahooFinanceMarketService: MarketServiceProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = URLSessionAPIClient()) {
        self.apiClient = apiClient
    }

    func fetchMarketItems(region: MarketRegion = .us) async throws -> [MarketItem] {
        let response = try await apiClient.request(.marketSummary(region: region),
                                                   as: MarketSummaryResponseDTO.self)
        
        return response
            .marketSummaryAndSparkResponse
            .result
            .compactMap { $0.toDomain() }
    }

    func fetchStockSummary(symbol: String, region: MarketRegion = .us) async throws -> StockSummaryResponseDTO {
        try await apiClient.request(.stockSummary(symbol: symbol, region: region),
                                    as: StockSummaryResponseDTO.self)
    }
}
