//
//  SafariWebExtensionHandler.swift
//  Reroute Extension
//
//  Created by Shawn Davis on 10/6/21.
//

import SafariServices
import OSLog

import SafariServices

let SFExtensionMessageKey = "message"

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        guard let item = context.inputItems.first as? NSExtensionItem,
              let userInfo = item.userInfo as? [String: Any],
              let message = userInfo[SFExtensionMessageKey] as? String,
              let url = URL(string: message)
        else {
            Logger.safariExt.error("Could not decipher message from browser")
            context.completeRequest(returningItems: nil, completionHandler: nil)
            return
        }
        
        Logger.safariExt.notice("Expanding URL \(message)")
        
        let response = NSExtensionItem()
        response.userInfo = [ SFExtensionMessageKey: [ "url": url ] ]
        
        context.completeRequest(returningItems: [response], completionHandler: nil)
    }
}
