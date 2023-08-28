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
                .foregroundColor(.primary)
        } icon: {
            configuration.icon
                .font(.system(size: 14))
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
                .hidden()
                .overlay(content: {
                    configuration.icon
                        .font(.title)
                        .bold()
                        .foregroundColor(.accentColor)
                })
        }
    }
}

struct OutboundLinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .tint(.primary)
            Spacer()
            Image(systemName: "arrow.up.forward")
                .accessibility(hidden: true)
                .font(Font.system(size: 13, weight: .bold, design: .default))
                .foregroundStyle(.tertiary)
        }
#if os(macOS)
        .buttonStyle(.plain)
#else
        .hoverEffect(.highlight)
#endif
        .opacity(configuration.isPressed ? 0.5 : 1)
        .contentShape(Rectangle())
    }
}
