//
//  Date+Formatting.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import Foundation

extension Date {
    var timeWithSecondsText: String {
        formatted(
            .dateTime
                .hour()
                .minute()
                .second()
        )
    }
}
