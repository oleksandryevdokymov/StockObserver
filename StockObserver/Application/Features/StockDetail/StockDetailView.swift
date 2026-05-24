//
//  StockDetailView.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import SwiftUI

struct StockDetailView<ViewModel: StockDetailViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    private var detail: StockDetail {
        viewModel.detail
    }

    private var changeColor: Color {
        detail.change >= 0 ? .green : .red
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                header

                if viewModel.isLoading {
                    ProgressView("Loading details...")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if let message = viewModel.nonBlockingMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if detail.sparkCloseValues.count > 1 {
                    DetailCardView(title: "Price Movement") {
                        SparklineView(
                            values: detail.sparkCloseValues,
                            lineColor: changeColor
                        )
                        .frame(height: 120)
                    }
                }

                DetailCardView(title: "Market Details") {
                    VStack(spacing: 12) {
                        DetailRowView(title: "Current Price", value: detail.price.decimalText())
                        DetailRowView(title: "Previous Close", value: detail.previousClose.decimalText())
                        DetailRowView(title: "Change", value: detail.change.signedDecimalText(), valueColor: changeColor)
                        DetailRowView(title: "Change %", value: detail.changePercent.signedPercentText(), valueColor: changeColor)
                        DetailRowView(title: "Market State", value: detail.marketState ?? "N/A")
                        DetailRowView(title: "Quote Type", value: detail.quoteType ?? "N/A")
                    }
                }

                DetailCardView(title: "Exchange") {
                    VStack(spacing: 12) {
                        DetailRowView(title: "Exchange", value: detail.exchange ?? "N/A")
                        DetailRowView(title: "Full Exchange Name", value: detail.fullExchangeName ?? "N/A")
                        DetailRowView(title: "Region", value: detail.region ?? "N/A")
                        DetailRowView(title: "Currency", value: detail.currency ?? "N/A")
                        DetailRowView(title: "Last Market Time", value: detail.lastMarketTime ?? "N/A")
                    }
                }

                if let businessSummary = detail.businessSummary,
                   !businessSummary.isEmpty {
                    DetailCardView(title: "Company Summary") {
                        Text(businessSummary)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(detail.symbol)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(detail.name)
                        .font(.title2.bold())
                        .lineLimit(2)

                    Text(detail.symbol)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(detail.price.decimalText())
                    .font(.largeTitle.bold())
                    .monospacedDigit()

                Text(detail.changePercent.signedPercentText())
                    .font(.headline)
                    .foregroundStyle(changeColor)
                    .monospacedDigit()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
