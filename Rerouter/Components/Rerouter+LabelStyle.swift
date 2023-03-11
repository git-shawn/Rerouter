//
//  ColorfulIconLabelStyle.swift
//  Rerouter
//
//  Created by Shawn Davis on 3/2/23.
//

import Foundation
import SwiftUI

/// Credit to Boothosh81 at https://stackoverflow.com/a/69837612/20422552
struct ColorfulIconLabelStyle: LabelStyle {
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            configuration.icon
                .font(.system(size: 16))
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 7).frame(width: 28, height: 28).foregroundColor(color))
                .padding(.trailing, 8)
        }
    }
}

struct GettingStartedLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
                .font(.title2)
                .foregroundColor(.secondary)
        } icon: {
            Image(systemName: "rectangle")
                .font(.largeTitle)
                .bold()
                .hidden()
                .overlay(content: {
                    configuration.icon
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.accentColor)
                })
        }
    }
}
