//
//  StockDetailViewModel.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import Combine
import Foundation

@MainActor
protocol StockDetailViewModelProtocol: ObservableObject {
    var detail: StockDetail { get }
    var isLoading: Bool { get }
    var nonBlockingMessage: String? { get }

    func load() async
}

@MainActor
final class StockDetailViewModel: StockDetailViewModelProtocol {
    @Published private(set) var detail: StockDetail
    @Published private(set) var isLoading = false
    @Published private(set) var nonBlockingMessage: String?

    private let marketItem: MarketItem
    private let marketService: MarketServiceProtocol
    private let region: MarketRegion

    private var didLoad = false

    init(marketItem: MarketItem,
         marketService: MarketServiceProtocol,
         region: MarketRegion = .us) {
        self.marketItem = marketItem
        self.marketService = marketService
        self.region = region
        self.detail = StockDetail.fallback(from: marketItem)
    }

    func load() async {
        guard !didLoad else { return }

        didLoad = true
        isLoading = true

        defer {
            isLoading = false
        }

        do {
            let response = try await marketService.fetchStockSummary(symbol: marketItem.symbol,
                                                                     region: region)

            detail = response.toDomain(fallback: marketItem)
            nonBlockingMessage = nil
        } catch APIError.noContent, APIError.emptyResponse {
            detail = StockDetail.fallback(from: marketItem)
            nonBlockingMessage = nil
        } catch {
            detail = StockDetail.fallback(from: marketItem)
            nonBlockingMessage = "Showing available market summary data."
        }
    }
}
