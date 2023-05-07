//
//  IntentProvider.swift
//  Rerouter
//
//  Created by Shawn Davis on 5/7/23.
//

import SwiftUI
import AppIntents

struct RerouterShortcuts: AppShortcutsProvider {
    static var shortcutTileColor: ShortcutTileColor = .blue
    
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: RouteIntent(),
            phrases: ["Convert to Maps URL with \(.applicationName)"],
            shortTitle: "Convert to Maps URL",
            systemImageName: "location.circle")
    }
}
