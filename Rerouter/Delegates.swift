//
//  Delegates.swift
//  Rerouter
//
//  Created by Shawn Davis on 10/31/22.
//
import UIKit
import SwiftUI

var shortcutItemToProcess: UIApplicationShortcutItem?

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if let shortcutItem = options.shortcutItem {
            shortcutItemToProcess = shortcutItem
        }
        
        let sceneConfiguration = UISceneConfiguration(name: "Custom Configuration", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = CustomSceneDelegate.self
        
        return sceneConfiguration
    }
}

class CustomSceneDelegate: UIResponder, UIWindowSceneDelegate {
    @AppStorage("manual", store: UserDefaults(suiteName: "group.shwndvs.Rerouter")) var isManual: Bool = false
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        shortcutItemToProcess = shortcutItem
        
        if shortcutItem.type == "manual" {
            isManual = true
            addQuickActions()
        } else if shortcutItem.type == "auto" {
            isManual = false
            addQuickActions()
        }
    }
}
