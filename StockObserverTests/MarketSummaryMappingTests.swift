//
//  MarketSummaryMappingTests.swift
//  StockObserverTests
//
//  Created by Oleksandr Yevdokymov on 24.05.2026.
//

import Testing
import Foundation
@testable import StockObserver

struct MarketSummaryMappingTests {
    @Test
    func marketSummaryItemMapsToDomainModel() {
        let dto = TestDataFactory.marketSummaryItemDTO(symbol: "AAPL",
                                                       shortName: "Apple Inc.",
                                                       price: 200,
                                                       previousClose: 190)

        let item = dto.toDomain()

        #expect(item?.symbol == "AAPL")
        #expect(item?.name == "Apple Inc.")
        #expect(item?.price == 200)
        #expect(item?.previousClose == 190)
        #expect(item?.exchange == "NMS")
        #expect(item?.fullExchangeName == "NasdaqGS")
        #expect(item?.quoteType == "EQUITY")
        #expect(item?.marketState == "REGULAR")
        #expect(item?.region == "US")
        #expect(item?.sparkCloseValues == [190, 195, 200])
    }

    @Test
    func marketSummaryItemReturnsNilWhenSymbolIsMissing() {
        let dto = TestDataFactory.marketSummaryItemDTO(symbol: nil,
                                                       price: 200)

        #expect(dto.toDomain() == nil)
    }

    @Test
    func marketSummaryItemReturnsNilWhenPriceIsMissing() {
        let dto = TestDataFactory.marketSummaryItemDTO(symbol: "AAPL",
                                                       price: nil)

        #expect(dto.toDomain() == nil)
    }

    @Test
    func marketItemCalculatesChangeAndChangePercent() {
        let item = TestDataFactory.marketItem(symbol: "AAPL",
                                              name: "Apple Inc.",
                                              price: 200,
                                              previousClose: 190)

        #expect(item.change == 10)
        #expect(abs(item.changePercent - 5.2631) < 0.001)
    }
    
    @Test
    func marketItemChangePercentIsZeroWhenPreviousCloseIsZero() {
        let item = TestDataFactory.marketItem(price: 200,
                                              previousClose: 0)
        
        #expect(item.changePercent == 0)
    }
}
