//
//  MarketItem.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import Foundation

struct MarketItem: Identifiable, Hashable {
    let id: String
    let symbol: String
    let name: String
    let price: Double
    let formattedPrice: String?
    let previousClose: Double
    let formattedPreviousClose: String?
    let exchange: String?
    let fullExchangeName: String?
    let quoteType: String?
    let marketState: String?
    let region: String?
    let lastMarketTime: String?
    let sparkCloseValues: [Double]

    var change: Double {
        price - previousClose
    }

    var changePercent: Double {
        guard previousClose != 0 else { return 0 }
        return (change / previousClose) * 100
    }
}
