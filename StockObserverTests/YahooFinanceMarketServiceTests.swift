//
//  YahooFinanceMarketServiceTests.swift
//  StockObserverTests
//
//  Created by Oleksandr Yevdokymov on 24.05.2026.
//

import Testing
import Foundation
@testable import StockObserver

struct YahooFinanceMarketServiceTests {
    @Test
    func fetchMarketItemsRequestsMarketSummaryEndpointAndMapsDTOs() async throws {
        let apiClient = MockAPIClient(
            result: TestDataFactory.marketSummaryResponseDTO()
        )
        
        let service = YahooFinanceMarketService(apiClient: apiClient)
        
        let items = try await service.fetchMarketItems(region: .us)
        
        #expect(items.count == 1)
        #expect(items.first?.symbol == "AAPL")
        #expect(items.first?.name == "Apple Inc.")
        #expect(items.first?.price == 200)
        #expect(items.first?.previousClose == 190)
        
        #expect(apiClient.requestedEndpoints.count == 1)
        #expect(apiClient.requestedEndpoints.first?.path == "market/v2/get-summary")
        #expect(
            apiClient.requestedEndpoints.first?.queryItems.contains {
                $0.name == "region" && $0.value == "US"
            } == true
        )
    }
    
    @Test
    func fetchStockSummaryRequestsStockSummaryEndpoint() async throws {
        let apiClient = MockAPIClient(result: TestDataFactory.stockSummaryResponseDTO())
        
        let service = YahooFinanceMarketService(apiClient: apiClient)
        
        let response = try await service.fetchStockSummary(symbol: "AAPL", region: .us)
        
        #expect(response.price?.symbol == "AAPL")
        #expect(apiClient.requestedEndpoints.count == 1)
        #expect(apiClient.requestedEndpoints.first?.path == "stock/v2/get-summary")
        #expect(
            apiClient.requestedEndpoints.first?.queryItems.contains {
                $0.name == "symbol" && $0.value == "AAPL"
            } == true
        )
        #expect(
            apiClient.requestedEndpoints.first?.queryItems.contains {
                $0.name == "region" && $0.value == "US"
            } == true
        )
    }
    
    @Test
    func fetchMarketItemsPropagatesAPIClientError() async {
        let apiClient = MockAPIClient(error: APIError.rateLimited)
        
        let service = YahooFinanceMarketService(apiClient: apiClient)
        
        do {
            _ = try await service.fetchMarketItems(region: .us)
            #expect(Bool(false), "Expected fetchMarketItems to throw.")
        } catch APIError.rateLimited {
            #expect(true)
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }
}
