//
//  Double+Formatting.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import Foundation

extension Double {
    func decimalText(maxFractionDigits: Int = 2) -> String {
        formatted(.number.precision(.fractionLength(0...maxFractionDigits)))
    }

    func signedDecimalText(maxFractionDigits: Int = 2) -> String {
        let prefix = self > 0 ? "+" : ""
        return prefix + decimalText(maxFractionDigits: maxFractionDigits)
    }

    func percentText(maxFractionDigits: Int = 2) -> String {
        decimalText(maxFractionDigits: maxFractionDigits) + "%"
    }

    func signedPercentText(maxFractionDigits: Int = 2) -> String {
        signedDecimalText(maxFractionDigits: maxFractionDigits) + "%"
    }
}
