//
//  ShareButton.swift
//  Rerouter
//
//  Created by Shawn Davis on 11/19/22.
//

import SwiftUI

struct ShareButton: View {
    var title: String
    var shareURL: String
    
    var body: some View {
        if #available(iOS 16, *) {
            ShareLink(item: URL(string: shareURL)!, label: {
                Label {
                    Text(title)
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.accentColor)
                }
            })
        } else {
            Button(action: {
                showShareSheet(with: [URL(string: shareURL)!])
            }) {
                Label {
                    Text(title)
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
}

struct ShareButton_Previews: PreviewProvider {
    static var previews: some View {
        ShareButton(title: "Share", shareURL: "https://www.google.com")
    }
}
