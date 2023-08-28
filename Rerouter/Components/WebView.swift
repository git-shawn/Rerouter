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
        let view = WKWebView()
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        view.configuration.limitsNavigationsToAppBoundDomains = true
        view.configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        view.allowsBackForwardNavigationGestures = false
        view.allowsLinkPreview = false
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
