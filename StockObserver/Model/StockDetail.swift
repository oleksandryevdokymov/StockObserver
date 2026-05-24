//
//  StockDetail.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import Foundation

struct StockDetail: Equatable {
    enum Source: Equatable {
        case requiredEndpoint
        case marketSummaryFallback
    }

    let symbol: String
    let name: String
    let price: Double
    let previousClose: Double
    let exchange: String?
    let fullExchangeName: String?
    let quoteType: String?
    let marketState: String?
    let region: String?
    let currency: String?
    let lastMarketTime: String?
    let businessSummary: String?
    let sparkCloseValues: [Double]
    let source: Source

    var change: Double {
        price - previousClose
    }

    var changePercent: Double {
        guard previousClose != 0 else { return 0 }
        return (change / previousClose) * 100
    }
}

extension StockDetail {
    static func fallback(from item: MarketItem) -> StockDetail {
        StockDetail(
            symbol: item.symbol,
            name: item.name,
            price: item.price,
            previousClose: item.previousClose,
            exchange: item.exchange,
            fullExchangeName: item.fullExchangeName,
            quoteType: item.quoteType,
            marketState: item.marketState,
            region: item.region,
            currency: nil,
            lastMarketTime: item.lastMarketTime,
            businessSummary: nil,
            sparkCloseValues: item.sparkCloseValues,
            source: .marketSummaryFallback
        )
    }
}
