//
//  Logger.swift
//  Rerouter
//
//  Created by Shawn Davis on 7/28/23.
//

import OSLog

import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    /// Log errors that occur in the view
    static let view = Logger(subsystem: subsystem, category: "view")
    
    /// Log errors that occur in the safari extension
    static let safariExt = Logger(subsystem: subsystem, category: "safariExt")
    
    /// Log errors that occur in the tools
    static let tool = Logger(subsystem: subsystem, category: "tool")
}
