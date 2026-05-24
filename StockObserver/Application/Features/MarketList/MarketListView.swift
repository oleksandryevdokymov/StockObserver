//
//  MarketListView.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import SwiftUI

struct MarketListView<ViewModel: MarketListViewModelProtocol, DetailView: View>: View {
    @Environment(\.scenePhase) private var scenePhase

    @StateObject private var viewModel: ViewModel
    @State private var navigationPath = NavigationPath()

    private let makeDetailView: (MarketItem) -> DetailView

    init(viewModel: ViewModel,
        @ViewBuilder makeDetailView: @escaping (MarketItem) -> DetailView) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.makeDetailView = makeDetailView
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
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
        .onAppear {
            handleRefreshLifecycle()
        }
        .onDisappear {
            viewModel.stopAutoRefresh()
        }
        .onChange(of: scenePhase) { _, _ in
            handleRefreshLifecycle()
        }
        .onChange(of: navigationPath.count) { _, _ in
            handleRefreshLifecycle()
        }
    }

    // MARK: - Auto-refresh Lifecycle
    //
    // The market list should refresh only when it is actively visible to the user.
    //
    // Rules:
    //
    // 1. User opens the app / MarketListView appears
    //    scenePhase == .active
    //    navigationPath.isEmpty == true
    //    → startAutoRefresh()
    //
    // 2. User taps a market item and navigates to StockDetailView
    //    navigationPath.count becomes 1
    //    navigationPath.isEmpty == false
    //    → stopAutoRefresh()
    //
    // 3. User returns from StockDetailView back to MarketListView
    //    navigationPath.count becomes 0
    //    navigationPath.isEmpty == true
    //    scenePhase == .active
    //    → startAutoRefresh()
    //
    // 4. User sends the app to background / app becomes inactive
    //    scenePhase == .background or .inactive
    //    → stopAutoRefresh()
    //
    // 5. User opens the app again
    //    scenePhase == .active
    //
    //    If user is on MarketListView:
    //        navigationPath.isEmpty == true
    //        → startAutoRefresh()
    //
    //    If user is still on StockDetailView:
    //        navigationPath.isEmpty == false
    //        → keep auto-refresh stopped
    //
    // This avoids unnecessary API requests while the list is not visible and protects
    // the limited RapidAPI quota. The ViewModel also guards against duplicate refresh
    // tasks, so calling startAutoRefresh() multiple times is safe.
    private func handleRefreshLifecycle() {
        if shouldAutoRefresh {
            viewModel.startAutoRefresh()
        } else {
            viewModel.stopAutoRefresh()
        }
    }
    
    private var shouldAutoRefresh: Bool {
        scenePhase == .active && navigationPath.isEmpty
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
