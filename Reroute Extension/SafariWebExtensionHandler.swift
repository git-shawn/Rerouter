//
//  SafariWebExtensionHandler.swift
//  Reroute Extension
//
//  Created by Shawn Davis on 10/6/21.
//

import SafariServices
import os.log

import SafariServices

let SFExtensionMessageKey = "message"

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {

        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey]
        
        // Rerouter's app group, where preferences are stored.
        let defaults = UserDefaults(suiteName: "group.shwndvs.Rerouter")
        
        let messageDictionary = message as? [String: String]
        if messageDictionary?[SFExtensionMessageKey] == "getDefaults" {
            
            let automatic = defaults?.bool(forKey: "automatic") ?? true
            let openableLinks = defaults?.integer(forKey: "openableLinks") ?? 0
            
            let response = NSExtensionItem()
            response.userInfo = [ SFExtensionMessageKey: [ "automatic": automatic, "openableLinks": openableLinks ] ]
            context.completeRequest(returningItems: [response], completionHandler: nil)
        }
    }
}
