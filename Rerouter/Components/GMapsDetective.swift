//
//  GMapsDetective.swift
//  Rerouter
//
//  Created by Shawn Davis on 8/28/23.
//

import SwiftUI

struct GMapsDetective: View {
    @State private var showDetails: Bool = false;
    @State private var isGMapsInstalled: Bool = false
    @AppStorage("showGmapsAlert") private var showGmapsAlert: Bool = true
    
    var body: some View {
        Group {
            if isGMapsInstalled && showGmapsAlert {
                VStack(alignment: .leading) {
                    HStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.title)
                        Text("Rerouter may not function as expected with Google Maps installed.")
                    }
                }
                .onTapGesture {
                    showDetails = true
                }
                .scenePadding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThickMaterial)
                        .shadow(
                            color: .secondary.opacity(0.15),
                            radius: 12,
                            x: 0,
                            y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.tertiary, lineWidth: 1)
                        )
                )
                .frame(maxWidth: 350)
                .scenePadding()
                .sheet(isPresented: $showDetails) {
                    NavigationStack {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("How Does the Google Maps Apps Affect Rerouter?")
                                    .font(.title2)
                                    .bold()
                                Text("""
Rerouter was designed to work on *any* website, not just on a Google search results page. The way it accomplishes that is by observing the URL of the website you're currently visiting and, if it matches the known Google Maps URL structure, rerouting it on-the-fly.

The Google Maps website and the Google Maps apps are *associated with* each other via a system Apple calls ["Universal Links"](https://developer.apple.com/ios/universal-links/). With universal links, websites can open their associated apps directly in a way that extensions, like Rerouter, cannot interrupt.
""")
                                Text("Is There a Way Around This?")
                                    .font(.title2)
                                    .bold()
                                Text("""
At this moment, no. There is currently no system in place to "opt out" of Universal Links. If you discover a workaround yourself please email me at [contact@fromshawn.dev](mailto:contact@fromshawn.dev).
""")
                                
                                GroupBox {
                                    Toggle("Show Google Maps Warning?", isOn: $showGmapsAlert)
                                        .tint(.accentColor)
                                }
                            }
                            .scenePadding()
                            .navigationTitle("About Google Maps")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                Button("Done", action: {
                                    showDetails = false
                                })
                            }
                        }
                    }
                }
            }
        }
        .task {
            isGMapsInstalled = UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
        }
    }
}

struct GMapsDetective_Previews: PreviewProvider {
    static var previews: some View {
        GMapsDetective()
    }
}
