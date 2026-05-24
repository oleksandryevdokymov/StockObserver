//
//  MarketRowView.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import SwiftUI

struct MarketRowView: View {
    let item: MarketItem

    private var changeColor: Color {
        item.change >= 0 ? .green : .red
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                        .lineLimit(1)

                    Text(item.symbol)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(item.formattedPrice ?? item.price.decimalText())
                        .font(.headline)
                        .monospacedDigit()

                    Text(item.changePercent.signedPercentText())
                        .font(.subheadline)
                        .foregroundStyle(changeColor)
                        .monospacedDigit()
                }
            }

            if item.sparkCloseValues.count > 1 {
                SparklineView(values: item.sparkCloseValues,
                    lineColor: changeColor)
                .frame(height: 36)
            }
        }
        .padding(.vertical, 6)
    }
}
