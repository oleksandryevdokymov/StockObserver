//
//  StockDetailViewModelTests.swift
//  StockObserverTests
//
//  Created by Oleksandr Yevdokymov on 24.05.2026.
//

import Testing
import Foundation
@testable import StockObserver

@MainActor
struct StockDetailViewModelTests {
    @Test
    func initialStateUsesFallbackDetailFromMarketItem() {
        let marketItem = TestDataFactory.marketItem(symbol: "AAPL",
                                                    name: "Apple Inc.",
                                                    price: 200,
                                                    previousClose: 190)
        
        let service = MockMarketService()
        let viewModel = StockDetailViewModel(marketItem: marketItem,
                                             marketService: service,
                                             region: .us)
        
        #expect(viewModel.detail.symbol == "AAPL")
        #expect(viewModel.detail.name == "Apple Inc.")
        #expect(viewModel.detail.price == 200)
        #expect(viewModel.detail.previousClose == 190)
        #expect(viewModel.detail.source == .marketSummaryFallback)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.nonBlockingMessage == nil)
    }
    
    @Test
    func loadUsesRequiredEndpointResponseWhenAvailable() async {
        let marketItem = TestDataFactory.marketItem(symbol: "AAPL",
                                                    name: "Fallback Apple",
                                                    price: 200,
                                                    previousClose: 190)
        
        let service = MockMarketService(stockSummaryResult:
                .success(TestDataFactory.stockSummaryResponseDTO(symbol: "AAPL",
                                                                 longName: "Apple Inc.",
                                                                 price: 210,
                                                                 previousClose: 200))
        )
        
        let viewModel = StockDetailViewModel(marketItem: marketItem,
                                             marketService: service,
                                             region: .us)
        
        await viewModel.load()
        
        #expect(viewModel.detail.symbol == "AAPL")
        #expect(viewModel.detail.name == "Apple Inc.")
        #expect(viewModel.detail.price == 210)
        #expect(viewModel.detail.previousClose == 200)
        #expect(viewModel.detail.currency == "USD")
        #expect(viewModel.detail.businessSummary != nil)
        #expect(viewModel.detail.source == .requiredEndpoint)
        #expect(viewModel.nonBlockingMessage == nil)
        #expect(viewModel.isLoading == false)
        #expect(service.fetchStockSummaryCallCount == 1)
        #expect(service.requestedSymbols == ["AAPL"])
    }
    
    @Test
    func loadFallsBackSilentlyWhenEndpointReturnsNoContent() async {
        let marketItem = TestDataFactory.marketItem(symbol: "AAPL",
                                                    name: "Apple Inc.",
                                                    price: 200,
                                                    previousClose: 190)
        
        let service = MockMarketService(stockSummaryResult: .failure(APIError.noContent))
        
        let viewModel = StockDetailViewModel(marketItem: marketItem,
                                             marketService: service,
                                             region: .us)
        
        await viewModel.load()
        
        #expect(viewModel.detail.symbol == "AAPL")
        #expect(viewModel.detail.price == 200)
        #expect(viewModel.detail.previousClose == 190)
        #expect(viewModel.detail.source == .marketSummaryFallback)
        #expect(viewModel.nonBlockingMessage == nil)
        #expect(viewModel.isLoading == false)
        #expect(service.fetchStockSummaryCallCount == 1)
    }
    
    @Test
    func loadFallsBackWithMessageForUnexpectedError() async {
        let marketItem = TestDataFactory.marketItem( symbol: "AAPL",
                                                     name: "Apple Inc.",
                                                     price: 200,
                                                     previousClose: 190)
        
        let service = MockMarketService(stockSummaryResult: .failure(MockServiceError.failed))
        
        let viewModel = StockDetailViewModel( marketItem: marketItem,
                                              marketService: service,
                                              region: .us)
        
        await viewModel.load()
        
        #expect(viewModel.detail.source == .marketSummaryFallback)
        #expect(viewModel.nonBlockingMessage == "Showing available market summary data.")
        #expect(viewModel.isLoading == false)
        #expect(service.fetchStockSummaryCallCount == 1)
    }
    
    @Test
    func loadIsPerformedOnlyOnce() async {
        let marketItem = TestDataFactory.marketItem()
        
        let service = MockMarketService(stockSummaryResult: .failure(APIError.noContent))
        
        let viewModel = StockDetailViewModel( marketItem: marketItem,
                                              marketService: service,
                                              region: .us)
        
        await viewModel.load()
        await viewModel.load()
        await viewModel.load()
        
        #expect(service.fetchStockSummaryCallCount == 1)
    }
}
