//
//  MarketSummaryItemDTO+Mapping.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import Foundation

extension MarketSummaryItemDTO {
    func toDomain() -> MarketItem? {
        guard let symbol else {
            return nil
        }

        guard let price = regularMarketPrice?.raw else {
            return nil
        }

        let previousClose = regularMarketPreviousClose?.raw
            ?? spark?.previousClose
            ?? price

        let name = shortName
            ?? fullExchangeName
            ?? symbol

        return MarketItem(
            id: symbol,
            symbol: symbol,
            name: name,
            price: price,
            formattedPrice: regularMarketPrice?.fmt,
            previousClose: previousClose,
            formattedPreviousClose: regularMarketPreviousClose?.fmt,
            exchange: exchange,
            fullExchangeName: fullExchangeName,
            quoteType: quoteType,
            marketState: marketState,
            region: region,
            lastMarketTime: regularMarketTime?.fmt,
            sparkCloseValues: spark?.close?.compactMap { $0 } ?? []
        )
    }
}
