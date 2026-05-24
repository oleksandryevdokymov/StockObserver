//
//  StockObserverApp.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import SwiftUI

@main
struct StockObserverApp: App {
    private let dependencyContainer = AppDependencyContainer()

    var body: some Scene {
        WindowGroup {
            StockObserverView(dependencyContainer: dependencyContainer)
        }
    }
}
