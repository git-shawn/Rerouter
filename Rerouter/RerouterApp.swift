//
//  Rerouter.swift
//  Rerouter
//
//  Created by Shawn Davis on 1/3/22.
//

import SwiftUI
import StoreKit
import OSLog

@main
struct Rerouter: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            
            //MARK: - Handle external purchases
                .task(priority: .background) {
                    RerouterShortcuts.updateAppShortcutParameters()
                    
                    for await result in StoreKit.Transaction.updates {
                        switch result {
                        case .verified(let transaction):
                            await transaction.finish()
                            // Tipping is not available outside of the App Store.
                        case .unverified(_,_):
                            Logger(subsystem: "shwndvs.Rerouter", category: "StoreKit").notice("An unverified transaction was found.")
                        }
                    }
                }
        }
        
        // MARK: - Add Commands to Menubar for Mac Catalyst
#if targetEnvironment(macCatalyst)
        .commands {
            CommandGroup(replacing: .help) {
                Link("Rerouter Help", destination: URL(string: "https://www.fromshawn.dev/support?tag=rerouter")!)
                Link("Contact Me", destination: URL(string: "mailto:contact@fromshawn.dev")!)
            }
        }
#endif
    }
}
