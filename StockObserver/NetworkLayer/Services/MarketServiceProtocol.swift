//
//  MarketServiceProtocol.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import Foundation

protocol MarketServiceProtocol {
    func fetchMarketItems(region: MarketRegion) async throws -> [MarketItem]

    /// Required by the task specification.
    /// Currently this endpoint returns 204 No Content on RapidAPI.
    func fetchStockSummary(symbol: String, region: MarketRegion) async throws -> StockSummaryResponseDTO
}
