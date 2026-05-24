//
//  StockObserverView.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import SwiftUI

struct StockObserverView: View {
    private let dependencyContainer: AppDependencyContainer

    @StateObject private var viewModel: MarketListViewModel

    init(dependencyContainer: AppDependencyContainer) {
        self.dependencyContainer = dependencyContainer
        _viewModel = StateObject(
            wrappedValue: dependencyContainer.makeMarketListViewModel()
        )
    }

    var body: some View {
        MarketListView(viewModel: viewModel) { item in
            StockDetailView(
                viewModel: dependencyContainer.makeStockDetailViewModel(for: item)
            )
        }
    }
}
