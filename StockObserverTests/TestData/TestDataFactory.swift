//
//  TestDataFactory.swift
//  StockObserverTests
//
//  Created by Oleksandr Yevdokymov on 24.05.2026.
//

import Foundation
@testable import StockObserver

enum TestDataFactory {
    static func marketItem(symbol: String = "AAPL",
                           name: String = "Apple Inc.",
                           price: Double = 200,
                           previousClose: Double = 190) -> MarketItem {
        MarketItem(id: symbol,
                   symbol: symbol,
                   name: name,
                   price: price,
                   formattedPrice: "\(price)",
                   previousClose: previousClose,
                   formattedPreviousClose: "\(previousClose)",
                   exchange: "NMS",
                   fullExchangeName: "NasdaqGS",
                   quoteType: "EQUITY",
                   marketState: "REGULAR",
                   region: "US",
                   lastMarketTime: "14:34:43",
                   sparkCloseValues: [previousClose, 195, price])
    }

    static func marketSummaryItemDTO(symbol: String? = "AAPL",
                                     shortName: String? = "Apple Inc.",
                                     price: Double? = 200,
                                     previousClose: Double? = 190) -> MarketSummaryItemDTO {
        MarketSummaryItemDTO(fullExchangeName: "NasdaqGS",
                             symbol: symbol,
                             gmtOffSetMilliseconds: nil,
                             language: "en-US",
                             regularMarketTime: FormattedValueDTO(raw: nil, fmt: "14:34:43"),
                             quoteType: "EQUITY",
                             spark: SparkDTO(timestamp: [1, 2, 3],
                                             symbol: symbol,
                                             close: [previousClose, 195, price],
                                             end: nil,
                                             start: nil,
                                             previousClose: previousClose,
                                             chartPreviousClose: previousClose,
                                             dataGranularity: nil),
                             tradeable: false,
                             regularMarketPreviousClose: previousClose.map { FormattedValueDTO(raw: $0, fmt: "\($0)") },
                             exchangeTimezoneName: nil,
                             cryptoTradeable: false,
                             exchangeDataDelayedBy: nil,
                             firstTradeDateMilliseconds: nil,
                             exchangeTimezoneShortName: nil,
                             hasPrePostMarketData: nil,
                             regularMarketPrice: price.map { FormattedValueDTO(raw: $0, fmt: "\($0)") },
                             customPriceAlertConfidence: nil,
                             marketState: "REGULAR",
                             market: "us_market",
                             priceHint: nil,
                             sourceInterval: nil,
                             exchange: "NMS",
                             region: "US",
                             shortName: shortName,
                             triggerable: true)
    }

    static func marketSummaryResponseDTO(items: [MarketSummaryItemDTO] = [marketSummaryItemDTO()]) -> MarketSummaryResponseDTO {
        MarketSummaryResponseDTO(marketSummaryAndSparkResponse: MarketSummaryAndSparkResponseDTO(result: items,
                                                                                                 error: nil))
    }

    static func stockSummaryResponseDTO(symbol: String = "AAPL",
                                        longName: String = "Apple Inc.",
                                        price: Double = 210,
                                        previousClose: Double = 200) -> StockSummaryResponseDTO {
        StockSummaryResponseDTO(price: StockPriceDTO(symbol: symbol,
                                                     shortName: "Apple",
                                                     longName: longName,
                                                     quoteType: "EQUITY",
                                                     marketState: "REGULAR",
                                                     exchangeName: "NasdaqGS",
                                                     currency: "USD",
                                                     regularMarketPrice: FormattedValueDTO(raw: price, fmt: "\(price)"),
                                                     regularMarketChange: nil,
                                                     regularMarketChangePercent: nil,
                                                     regularMarketPreviousClose: FormattedValueDTO(raw: previousClose, fmt: "\(previousClose)")),
                                summaryDetail: nil,
                                financialData: nil,
                                defaultKeyStatistics: nil,
                                quoteType: StockQuoteTypeDTO(symbol: symbol,
                                                             quoteType: "EQUITY",
                                                             shortName: "Apple",
                                                             longName: longName,
                                                             exchange: "NMS"),
                                assetProfile: StockAssetProfileDTO(address1: nil,
                                                                   city: nil,
                                                                   state: nil,
                                                                   country: nil,
                                                                   website: nil,
                                                                   industry: "Consumer Electronics",
                                                                   sector: "Technology",
                                                                   longBusinessSummary: "Apple Inc. designs and sells consumer electronics.",
                                                                   fullTimeEmployees: nil),
                                summaryProfile: nil)
    }
}
