//
//  StockSummaryResponseDTO+Mapping.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import Foundation

extension StockSummaryResponseDTO {
    func toDomain(fallback item: MarketItem) -> StockDetail {
        let priceDTO = price
        let summaryDTO = summaryDetail
        let financialDTO = financialData
        let quoteDTO = quoteType
        let profileDTO = assetProfile ?? summaryProfile

        let currentPrice = priceDTO?.regularMarketPrice?.raw
            ?? financialDTO?.currentPrice?.raw
            ?? item.price

        let previousClose = priceDTO?.regularMarketPreviousClose?.raw
            ?? summaryDTO?.previousClose?.raw
            ?? item.previousClose

        let name = priceDTO?.longName
            ?? priceDTO?.shortName
            ?? quoteDTO?.longName
            ?? quoteDTO?.shortName
            ?? item.name

        return StockDetail(
            symbol: priceDTO?.symbol ?? quoteDTO?.symbol ?? item.symbol,
            name: name,
            price: currentPrice,
            previousClose: previousClose,
            exchange: quoteDTO?.exchange ?? item.exchange,
            fullExchangeName: priceDTO?.exchangeName ?? item.fullExchangeName,
            quoteType: priceDTO?.quoteType ?? quoteDTO?.quoteType ?? item.quoteType,
            marketState: priceDTO?.marketState ?? item.marketState,
            region: item.region,
            currency: priceDTO?.currency,
            lastMarketTime: item.lastMarketTime,
            businessSummary: profileDTO?.longBusinessSummary,
            sparkCloseValues: item.sparkCloseValues,
            source: .requiredEndpoint
        )
    }
}
