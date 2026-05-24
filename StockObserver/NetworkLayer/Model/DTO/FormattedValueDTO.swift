//
//  FormattedValueDTO.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import Foundation

struct FormattedValueDTO: Decodable {
    let raw: Double?
    let fmt: String?
}
