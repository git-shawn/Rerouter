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
    @AppStorage("showGMapsAlert") private var showGMapsAlert: Bool = true
    
    var body: some View {
        Group {
            if isGMapsInstalled && showGMapsAlert {
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
                .frame(maxWidth: 400)
                .scenePadding()
                .sheet(isPresented: $showDetails) {
                    NavigationStack {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("How Does the Google Maps Apps Affect Rerouter?")
                                    .font(.title2)
                                    .bold()
                                Text("""
Rerouter works by observing the URL of the site you are currently visiting and reacting to it. If the URL matches a structure Rerouter knows to be Google Maps, it is taken apart and reconstructed as an Apple Maps URL. This new URL subsequently replaces the URL in your browser. The entire process takes just milliseconds.

This system allows Rerouter to work from any website—not just Google's search results pages. However, it's not without caveats. Mainly, Rerouter must actually visit the URL it wants to Reroute. The page doesn't necessarily need to load, but Safari should at least attempt to navigate to it.

Some websites employ a system Apple calls [Universal Links](https://developer.apple.com/ios/universal-links/), which directly associates a website with an app. The Universal Links system intercepts web traffic and redirects it to the correct app. With Universal Links, redirection happens at the system level, not Safari. That means Rerouter never sees the URL in the first place.
""")
                                
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
                        .safeAreaInset(edge: .bottom) {
                            Button(action: {
                                showGMapsAlert = false
                            }, label: {
                                Text("Dismiss Warning")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            })
                            .buttonStyle(.borderedProminent)
                            .padding()
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
