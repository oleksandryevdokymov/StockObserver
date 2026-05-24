//
//  MarketListViewModelTests.swift
//  StockObserverTests
//
//  Created by Oleksandr Yevdokymov on 24.05.2026.
//

import Testing
import Foundation
@testable import StockObserver

@MainActor
struct MarketListViewModelTests {
    @Test
    func refreshLoadsMarketItems() async {
        let expectedItems = [
            TestDataFactory.marketItem(symbol: "^GSPC", name: "S&P 500"),
            TestDataFactory.marketItem(symbol: "^IXIC", name: "Nasdaq")
        ]
        
        let service = MockMarketService(marketItemsResult: .success(expectedItems))
        
        let viewModel = MarketListViewModel( marketService: service, region: .us)
        
        await viewModel.refresh()
        
        #expect(viewModel.items == expectedItems)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.isRefreshing == false)
        #expect(viewModel.lastUpdated != nil)
        #expect(service.fetchMarketItemsCallCount == 1)
        #expect(service.requestedRegions == [.us])
    }
    
    @Test
    func refreshFailureShowsErrorWhenNoCachedItemsExist() async {
        let service = MockMarketService(marketItemsResult: .failure(MockServiceError.failed))
        
        let viewModel = MarketListViewModel(marketService: service, region: .us)
        
        await viewModel.refresh()
        
        #expect(viewModel.items.isEmpty)
        #expect(viewModel.errorMessage == MockServiceError.failed.localizedDescription)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.isRefreshing == false)
        #expect(service.fetchMarketItemsCallCount == 1)
    }
    
    @Test
    func searchFiltersItemsByName() async {
        let items = [
            TestDataFactory.marketItem(symbol: "^GSPC", name: "S&P 500"),
            TestDataFactory.marketItem(symbol: "^IXIC", name: "Nasdaq"),
            TestDataFactory.marketItem(symbol: "^RUT", name: "Russell 2000")
        ]
        
        let service = MockMarketService(
            marketItemsResult: .success(items)
        )
        
        let viewModel = MarketListViewModel(marketService: service, region: .us)
        
        await viewModel.refresh()
        
        viewModel.searchText = "nas"
        
        #expect(viewModel.filteredItems.count == 1)
        #expect(viewModel.filteredItems.first?.name == "Nasdaq")
    }
    
    @Test
    func searchFiltersItemsBySymbol() async {
        let items = [
            TestDataFactory.marketItem(symbol: "^GSPC", name: "S&P 500"),
            TestDataFactory.marketItem(symbol: "^IXIC", name: "Nasdaq")
        ]
        
        let service = MockMarketService(marketItemsResult: .success(items))
        
        let viewModel = MarketListViewModel(marketService: service, region: .us)
        
        await viewModel.refresh()
        
        viewModel.searchText = "gspc"
        
        #expect(viewModel.filteredItems.count == 1)
        #expect(viewModel.filteredItems.first?.symbol == "^GSPC")
    }
    
    @Test
    func emptyStateIsShownWhenThereAreNoItemsAndNoError() {
        let service = MockMarketService()
        let viewModel = MarketListViewModel(marketService: service, region: .us)
        
        #expect(viewModel.shouldShowEmptyState == true)
    }
    
    @Test
    func startAutoRefreshTriggersInitialFetch() async throws {
        let items = [
            TestDataFactory.marketItem(symbol: "^GSPC", name: "S&P 500")
        ]
        
        let service = MockMarketService(marketItemsResult: .success(items))
        
        let viewModel = MarketListViewModel(marketService: service, region: .us)
        
        viewModel.startAutoRefresh()
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        viewModel.stopAutoRefresh()
        
        #expect(service.fetchMarketItemsCallCount >= 1)
        #expect(viewModel.items == items)
    }
    
    @Test
    func startAutoRefreshDoesNotCreateDuplicateImmediateRequests() async throws {
        let service = MockMarketService(marketItemsResult: .success([
            TestDataFactory.marketItem()
        ]))
        
        let viewModel = MarketListViewModel(marketService: service, region: .us)
        
        viewModel.startAutoRefresh()
        viewModel.startAutoRefresh()
        viewModel.startAutoRefresh()
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        viewModel.stopAutoRefresh()
        
        #expect(service.fetchMarketItemsCallCount == 1)
    }
}
