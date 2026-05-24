//
//  MarketListViewModel.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import Combine
import Foundation

@MainActor
protocol MarketListViewModelProtocol: ObservableObject {
    var items: [MarketItem] { get }
    var isLoading: Bool { get }
    var isRefreshing: Bool { get }
    var errorMessage: String? { get }
    var lastUpdated: Date? { get }
    var searchText: String { get set }

    var filteredItems: [MarketItem] { get }
    var shouldShowEmptyState: Bool { get }

    func startAutoRefresh()
    func stopAutoRefresh()
    func refresh() async
}

@MainActor
final class MarketListViewModel: MarketListViewModelProtocol {
    @Published private(set) var items: [MarketItem] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isRefreshing = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var lastUpdated: Date?

    @Published var searchText = ""

    private let marketService: MarketServiceProtocol
    private let region: MarketRegion

    private var refreshTask: Task<Void, Never>?

    init(marketService: MarketServiceProtocol,
        region: MarketRegion = .us) {
        self.marketService = marketService
        self.region = region
    }

    deinit {
        refreshTask?.cancel()
        refreshTask = nil
    }

    var filteredItems: [MarketItem] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !query.isEmpty else {
            return items
        }

        return items.filter { item in
            item.name.localizedCaseInsensitiveContains(query)
            || item.symbol.localizedCaseInsensitiveContains(query)
        }
    }

    var shouldShowEmptyState: Bool {
        !isLoading && errorMessage == nil && filteredItems.isEmpty
    }

    func startAutoRefresh() {
        guard refreshTask == nil else { return }

        refreshTask = Task { [weak self] in
            await self?.loadMarketItems(isBackgroundRefresh: false)

            while !Task.isCancelled {
                do {
                    try await Task.sleep(nanoseconds: 8_000_000_000)
                } catch {
                    break
                }

                await self?.loadMarketItems(isBackgroundRefresh: true)
            }
        }
    }

    func stopAutoRefresh() {
        refreshTask?.cancel()
        refreshTask = nil
    }

    func refresh() async {
        await loadMarketItems(isBackgroundRefresh: false)
    }

    private func loadMarketItems(isBackgroundRefresh: Bool) async {
        guard !isRefreshing else { return }

        isRefreshing = true

        if !isBackgroundRefresh && items.isEmpty {
            isLoading = true
        }

        defer {
            isRefreshing = false
            isLoading = false
        }

        do {
            let fetchedItems = try await marketService.fetchMarketItems(region: region)

            items = fetchedItems
            lastUpdated = Date()
            errorMessage = nil
        } catch APIError.cancelled {
            // Ignore cancellation.
            // This can happen when auto-refresh is stopped because the user navigates
            // to the detail screen or the app moves to the background.
        } catch is CancellationError {
            // Ignore task cancellation.
        } catch {
            if items.isEmpty || !isBackgroundRefresh {
                errorMessage = error.localizedDescription
            }
        }
    }
}
