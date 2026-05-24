//
//  SparklineView.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import SwiftUI

struct SparklineView: View {
    let values: [Double]
    let lineColor: Color

    var body: some View {
        GeometryReader { proxy in
            let normalizedPoints = normalizedPoints(
                in: proxy.size
            )

            Path { path in
                guard let firstPoint = normalizedPoints.first else { return }

                path.move(to: firstPoint)

                for point in normalizedPoints.dropFirst() {
                    path.addLine(to: point)
                }
            }
            .stroke(
                lineColor,
                style: StrokeStyle(
                    lineWidth: 2,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
        }
        .accessibilityHidden(true)
    }

    private func normalizedPoints(in size: CGSize) -> [CGPoint] {
        guard values.count > 1 else { return [] }

        let minValue = values.min() ?? 0
        let maxValue = values.max() ?? 0
        let range = max(maxValue - minValue, 0.0001)

        return values.enumerated().map { index, value in
            let x = size.width * CGFloat(index) / CGFloat(values.count - 1)
            let normalizedY = (value - minValue) / range
            let y = size.height * (1 - CGFloat(normalizedY))

            return CGPoint(x: x, y: y)
        }
    }
}
