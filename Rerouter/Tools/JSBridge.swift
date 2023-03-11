//
//  JSBridge.swift
//  Rerouter
//
//  Created by Shawn Davis on 3/2/23.
//

import Foundation
import JavaScriptCore

class JSBridge {
    func convertURL(text: String) -> String? {
        let jsPath = Bundle.main.path(forResource: "RouteManager", ofType: "js")
        do {
            let jsSource = try String(contentsOfFile:jsPath!, encoding: String.Encoding.utf8)
            let context = JSContext()
            
            context?.exceptionHandler = { context, exception in
                print("JS Error: \(exception?.description ?? "unknown error")")
            }
            context?.evaluateScript(jsSource)
            
            let routeFunction = context?.objectForKeyedSubscript("reroute")
            return routeFunction?.call(withArguments: [text]).toString()
        } catch {
            print("file not found :(")
            return nil
        }
    }
}
