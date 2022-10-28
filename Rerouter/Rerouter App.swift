//
//  Rerouter.swift
//  Rerouter
//
//  Created by Shawn Davis on 1/3/22.
//

import SwiftUI

@main
struct Rerouter: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            .onAppear(perform: {
                StoreManager.shared.startObserving()
                #if targetEnvironment(macCatalyst)
                UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
                    windowScene.sizeRestrictions?.minimumSize = CGSize(width: 500, height: 850)
                    windowScene.sizeRestrictions?.maximumSize = CGSize(width: 500, height: 850)
                }
                #endif
            })
            .onDisappear(perform: {
                StoreManager.shared.stopObserving()
            })
        }
        #if targetEnvironment(macCatalyst)
        .commands {
            CommandGroup(replacing: .help) {
                Link("Rerouter Help", destination: URL(string: "https://fromshawn.dev/rerouter.html")!)
                Link("Contact Me", destination: URL(string: "mailto:contact@fromshawn.dev")!)
            }
        }
        #endif
    }
}
