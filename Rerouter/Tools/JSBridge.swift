//
//  JSBridge.swift
//  Rerouter
//
//  Created by Shawn Davis on 3/2/23.
//

import Foundation
import JavaScriptCore
import OSLog

class JSBridge {
    func convertURL(text: String) -> String? {
        guard let jsPath = Bundle.main.path(forResource: "RouteManager", ofType: "js") else {
            Logger.tool.error("JSBridge: RouteManager not found in bundle.")
            return nil
        }
        do {
            let jsSource = try String(contentsOfFile:jsPath, encoding: String.Encoding.utf8)
            let context = JSContext()
            
            context?.exceptionHandler = { context, exception in
                Logger.tool.error("JSBridge: Error in JavaScript - \(exception?.description ?? "null").")
                print("JS Error: \(exception?.description ?? "unknown error")")
            }
            context?.evaluateScript(jsSource)
            
            let routeFunction = context?.objectForKeyedSubscript("reroute")
            return routeFunction?.call(withArguments: [text]).toString()
        } catch {
            Logger.tool.error("JSBridge: RouteManager not accessible in bundle.")
            return nil
        }
    }
}
