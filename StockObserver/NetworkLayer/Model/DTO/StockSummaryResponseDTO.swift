//
//  StockSummaryResponseDTO.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import Foundation

/* For now, this endpoint returns 204 No Content, but keep a DTO in case it starts returning data again. */
struct StockSummaryResponseDTO: Decodable {
    let price: StockPriceDTO?
    let summaryDetail: StockSummaryDetailDTO?
    let financialData: StockFinancialDataDTO?
    let defaultKeyStatistics: StockDefaultKeyStatisticsDTO?
    let quoteType: StockQuoteTypeDTO?
    let assetProfile: StockAssetProfileDTO?
    let summaryProfile: StockAssetProfileDTO?
}

struct StockPriceDTO: Decodable {
    let symbol: String?
    let shortName: String?
    let longName: String?
    let quoteType: String?
    let marketState: String?
    let exchangeName: String?
    let currency: String?

    let regularMarketPrice: FormattedValueDTO?
    let regularMarketChange: FormattedValueDTO?
    let regularMarketChangePercent: FormattedValueDTO?
    let regularMarketPreviousClose: FormattedValueDTO?
}

struct StockSummaryDetailDTO: Decodable {
    let previousClose: FormattedValueDTO?
    let open: FormattedValueDTO?
    let dayLow: FormattedValueDTO?
    let dayHigh: FormattedValueDTO?
    let volume: FormattedValueDTO?
    let averageVolume: FormattedValueDTO?
    let marketCap: FormattedValueDTO?
}

struct StockFinancialDataDTO: Decodable {
    let currentPrice: FormattedValueDTO?
    let targetHighPrice: FormattedValueDTO?
    let targetLowPrice: FormattedValueDTO?
    let targetMeanPrice: FormattedValueDTO?
    let recommendationMean: FormattedValueDTO?
    let recommendationKey: String?
}

struct StockDefaultKeyStatisticsDTO: Decodable {
    let enterpriseValue: FormattedValueDTO?
    let forwardPE: FormattedValueDTO?
    let profitMargins: FormattedValueDTO?
    let floatShares: FormattedValueDTO?
    let sharesOutstanding: FormattedValueDTO?
}

struct StockQuoteTypeDTO: Decodable {
    let symbol: String?
    let quoteType: String?
    let shortName: String?
    let longName: String?
    let exchange: String?
}

struct StockAssetProfileDTO: Decodable {
    let address1: String?
    let city: String?
    let state: String?
    let country: String?
    let website: String?
    let industry: String?
    let sector: String?
    let longBusinessSummary: String?
    let fullTimeEmployees: Int?
}
