//
//  MarketSummaryResponseDTO.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import Foundation

struct MarketSummaryResponseDTO: Decodable {
    let marketSummaryAndSparkResponse: MarketSummaryAndSparkResponseDTO
}

struct MarketSummaryAndSparkResponseDTO: Decodable {
    let result: [MarketSummaryItemDTO]
    let error: APIResponseErrorDTO?
}

struct APIResponseErrorDTO: Decodable {
    let code: String?
    let description: String?
}

struct MarketSummaryItemDTO: Decodable {
    let fullExchangeName: String?
    let symbol: String?
    let gmtOffSetMilliseconds: Int?
    let language: String?
    let regularMarketTime: FormattedValueDTO?
    let quoteType: String?
    let spark: SparkDTO?
    let tradeable: Bool?
    let regularMarketPreviousClose: FormattedValueDTO?
    let exchangeTimezoneName: String?
    let cryptoTradeable: Bool?
    let exchangeDataDelayedBy: Int?
    let firstTradeDateMilliseconds: Int?
    let exchangeTimezoneShortName: String?
    let hasPrePostMarketData: Bool?
    let regularMarketPrice: FormattedValueDTO?
    let customPriceAlertConfidence: String?
    let marketState: String?
    let market: String?
    let priceHint: Int?
    let sourceInterval: Int?
    let exchange: String?
    let region: String?
    let shortName: String?
    let triggerable: Bool?
}

struct SparkDTO: Decodable {
    let timestamp: [Int]?
    let symbol: String?
    let close: [Double?]?
    let end: Int?
    let start: Int?
    let previousClose: Double?
    let chartPreviousClose: Double?
    let dataGranularity: Int?
}
