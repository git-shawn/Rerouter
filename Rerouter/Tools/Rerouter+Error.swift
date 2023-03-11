//
//  Rerouter+Error.swift
//  Rerouter
//
//  Created by Shawn Davis on 3/2/23.
//

import Foundation
import SwiftUI

enum Error: LocalizedError {
case invalidURL, routingError, urlFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .routingError:
            return "Unable to Reroute"
        case .urlFailed:
            return "Unable to Open Maps"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidURL:
            return "Please submit a valid Google Maps URL"
        case .routingError:
            return "Make sure you submitted a complete Google Maps URL to Reroute"
        case .urlFailed:
            return "Rerouter could not open Maps with the submitted link"
        }
    }
}

/// https://www.avanderlee.com/swiftui/error-alert-presenting/
extension View {
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}

struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    var errorDescription: String? {
        underlyingError.errorDescription
    }
    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }

    init?(error: Error?) {
        guard let localizedError = error else { return nil }
        underlyingError = localizedError
    }
}
