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
                })
                .onDisappear(perform: {
                    StoreManager.shared.stopObserving()
                })
        }
#if targetEnvironment(macCatalyst)
        .commands {
            CommandGroup(replacing: .help) {
                Link("Rerouter Help", destination: URL(string: "https://www.fromshawn.dev/rerouter")!)
                Link("Contact Me", destination: URL(string: "mailto:contact@fromshawn.dev")!)
            }
        }
#endif
    }
}
