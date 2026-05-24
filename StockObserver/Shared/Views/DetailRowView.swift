//
//  DetailRowView.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import SwiftUI

struct DetailRowView: View {
    let title: String
    let value: String
    var valueColor: Color = .primary

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer(minLength: 16)

            Text(value)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(valueColor)
                .multilineTextAlignment(.trailing)
                .monospacedDigit()
        }
    }
}
