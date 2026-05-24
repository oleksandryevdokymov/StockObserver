//
//  MockMarketService.swift
//  StockObserverTests
//
//  Created by Oleksandr Yevdokymov on 24.05.2026.
//

import Foundation
@testable import StockObserver

final class MockMarketService: MarketServiceProtocol {
    var marketItemsResult: Result<[MarketItem], Error>
    var stockSummaryResult: Result<StockSummaryResponseDTO, Error>

    private(set) var fetchMarketItemsCallCount = 0
    private(set) var fetchStockSummaryCallCount = 0

    private(set) var requestedRegions: [MarketRegion] = []
    private(set) var requestedSymbols: [String] = []

    init(marketItemsResult: Result<[MarketItem], Error> = .success([]),
        stockSummaryResult: Result<StockSummaryResponseDTO, Error> = .failure(APIError.noContent)) {
        self.marketItemsResult = marketItemsResult
        self.stockSummaryResult = stockSummaryResult
    }

    func fetchMarketItems(region: MarketRegion) async throws -> [MarketItem] {
        fetchMarketItemsCallCount += 1
        requestedRegions.append(region)

        return try marketItemsResult.get()
    }

    func fetchStockSummary(symbol: String, region: MarketRegion) async throws -> StockSummaryResponseDTO {
        fetchStockSummaryCallCount += 1
        requestedSymbols.append(symbol)
        requestedRegions.append(region)
        
        return try stockSummaryResult.get()
    }
}

enum MockServiceError: Error, LocalizedError {
    case failed

    var errorDescription: String? {
        "Mock service failed."
    }
}
