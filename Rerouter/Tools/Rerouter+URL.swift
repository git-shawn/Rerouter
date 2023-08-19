//
//  Rerouter+URL.swift
//  Rerouter
//
//  Created by Shawn Davis on 7/28/23.
//

import Foundation
import OSLog

extension URL {
    func expand() async -> URL {
        var request = URLRequest(url: self)
        request.httpMethod = "HEAD"
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                Logger.tool.warning("URL.expand: Expanded URL returned an unsupported status code")
                return self
            }
            
            if let expandedURL = response.url {
                return expandedURL
            } else {
                Logger.tool.warning("URL.expand: Request was completed but URL could not be expanded")
                return self
            }
        } catch {
            Logger.tool.error("URL.expand: Could not request URL expansion")
            return self
        }
    }
}
