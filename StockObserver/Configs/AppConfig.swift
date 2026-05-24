//
//  AppConfig.swift
//  StockObserver
//
//  Created by Oleksandr Yevdokymov on 23.05.2026.
//

import Foundation

enum AppConfig {
    static var rapidAPIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "RAPID_API_KEY") as? String,
              !key.isEmpty,
              key != "PUT_YOUR_RAPIDAPI_KEY_HERE" else {
            assertionFailure("Missing RAPID_API_KEY. Add it to Secrets.xcconfig.")
            return ""
        }

        return key
    }

    static var rapidAPIHost: String {
        guard let host = Bundle.main.object(forInfoDictionaryKey: "RAPID_API_HOST") as? String,
              !host.isEmpty else {
            return "apidojo-yahoo-finance-v1.p.rapidapi.com"
        }

        return host
    }

    static var baseURL: URL {
        URL(string: "https://\(rapidAPIHost)")!
    }
}
