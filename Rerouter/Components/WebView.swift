//
//  WebView.swift
//  Rerouter
//
//  Created by Shawn Davis on 8/19/23.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {

        let request = URLRequest(url: url)
        // User cannot leave the domain
        webView.configuration.limitsNavigationsToAppBoundDomains = true
        // Prevents cookie persistence (essentially private browsing mode)
        webView.configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        webView.load(request)
    }
}
