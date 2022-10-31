//
//  Rerouter.swift
//  Rerouter
//
//  Created by Shawn Davis on 1/3/22.
//

import SwiftUI

@main
struct Rerouter: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: {
                    StoreManager.shared.startObserving()
#if targetEnvironment(macCatalyst)
                    UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
                        windowScene.sizeRestrictions?.minimumSize = CGSize(width: 600, height: 550)
                        windowScene.sizeRestrictions?.maximumSize = CGSize(width: 600, height: 550)
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
        .onChange(of: scenePhase) { scenePhase in
            switch scenePhase {
            case .background: addQuickActions()
            default: return
            }
        }
    }
}

func addQuickActions() {
    @AppStorage("manual", store: UserDefaults(suiteName: "group.shwndvs.Rerouter")) var isManual: Bool = false
    
    let manualMode = UIApplicationShortcutItem(
        type: "manual",
        localizedTitle: "Toggle Rerouting",
        localizedSubtitle: "Switch to manual mode",
        icon: UIApplicationShortcutIcon(systemImageName: "location.slash"),
        userInfo: nil
    )
    let autoMode = UIApplicationShortcutItem(
        type: "auto",
        localizedTitle: "Toggle Rerouting",
        localizedSubtitle: "Switch to automatic mode",
        icon: UIApplicationShortcutIcon(systemImageName: "location"),
        userInfo: nil
    )
    if (isManual) {
        UIApplication.shared.shortcutItems = [autoMode]
    } else {
        UIApplication.shared.shortcutItems = [manualMode]
    }
}
