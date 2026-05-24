//
//  AppDependencyContainer.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import Foundation

final class AppDependencyContainer {
    private lazy var apiClient: APIClient = URLSessionAPIClient()

    lazy var marketService: MarketServiceProtocol = YahooFinanceMarketService(
        apiClient: apiClient
    )

    @MainActor
    func makeMarketListViewModel() -> MarketListViewModel {
        MarketListViewModel(
            marketService: marketService,
            region: .us
        )
    }

    @MainActor
    func makeStockDetailViewModel(for item: MarketItem) -> StockDetailViewModel {
        StockDetailViewModel(
            marketItem: item,
            marketService: marketService,
            region: .us
        )
    }
}
