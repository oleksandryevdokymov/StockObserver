//
//  MarketListView.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import SwiftUI

struct MarketListView<ViewModel: MarketListViewModelProtocol, DetailView: View>: View {
    
    @StateObject private var viewModel: ViewModel

    private let makeDetailView: (MarketItem) -> DetailView
    
    init(viewModel: ViewModel,
        @ViewBuilder makeDetailView: @escaping (MarketItem) -> DetailView) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.makeDetailView = makeDetailView
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("StockObserver")
                .searchable(
                    text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .automatic),
                    prompt: "Search by name or symbol"
                )
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        refreshButton
                    }
                }
                .navigationDestination(for: MarketItem.self) { item in
                    makeDetailView(item)
                }
        }
        .task {
            viewModel.startAutoRefresh()
        }
        .onDisappear {
            viewModel.stopAutoRefresh()
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            LoadingView(title: "Loading market data...")
        } else if let errorMessage = viewModel.errorMessage {
            ErrorStateView(
                title: "Unable to Load Market Data",
                message: errorMessage,
                retryAction: {
                    Task {
                        await viewModel.refresh()
                    }
                }
            )
        } else if viewModel.shouldShowEmptyState {
            EmptyStateView(
                title: "No Results",
                message: "Try searching for another stock or market symbol."
            )
        } else {
            List {
                if let lastUpdated = viewModel.lastUpdated {
                    Section {
                        Text("Last updated: \(lastUpdated.timeWithSecondsText)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                Section {
                    ForEach(viewModel.filteredItems) { item in
                        NavigationLink(value: item) {
                            MarketRowView(item: item)
                        }
                    }
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }

    @ViewBuilder
    private var refreshButton: some View {
        if viewModel.isRefreshing {
            ProgressView()
                .controlSize(.small)
        } else {
            Button {
                Task {
                    await viewModel.refresh()
                }
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            .disabled(viewModel.isLoading)
        }
    }
}
