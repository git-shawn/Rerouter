//
//  Rerouter+String.swift
//  Rerouter
//
//  Created by Shawn Davis on 3/2/23.
//

import Foundation
import SwiftUI

// Thanks Milan - https://stackoverflow.com/a/49072718/20422552
extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
