//
//  LoadingView.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import SwiftUI

struct LoadingView: View {
    let title: String

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
