//
//  RouteIntent.swift
//  Rerouter
//
//  Created by Shawn Davis on 5/7/23.
//

import SwiftUI
import AppIntents

struct RouteIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Convert to Maps URL"
    static var description = IntentDescription("Use Rerouter to open a Google Maps URL to Maps.")
    
    static var authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed
    
    @Parameter(title: "URL", description: "A Google Maps URL to convert.")
    var url: URL
    
    static var parameterSummary: some ParameterSummary {
        Summary("Convert \(\.$url) to Maps URL.")
    }
    
    func perform() async throws -> some ReturnsValue<String> {
        let expandedURL = await url.expand()
        let newURL = JSBridge().convertURL(text: expandedURL.absoluteString)
        guard let resultString = newURL, !resultString.isEmpty else {
            throw $url.needsValueError("Rerouter could not convert the provided URL. Please try another.")
        }
        
        return .result(value: resultString)
    }
}
