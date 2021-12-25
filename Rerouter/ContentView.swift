//
//  ContentView.swift
//  Rerouter
//
//  Created by Shawn Davis on 10/6/21.
//

import SwiftUI
import StoreKit

/// Rerouter's initial view.
struct ContentView: View {
    @State private var showExtension: Bool = false
    @State private var showPrivacy: Bool = false
    @State private var showGuide: Bool = false
    @State private var showMaps: Bool = false
    
    @AppStorage("manual", store: UserDefaults(suiteName: "group.shwndvs.Rerouter")) var isManual: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                /// Google Maps takes uses Universal Links to redirect web visitors to their app.
                /// iOS prioritizes Universal Links (understandably), so we likely won't even get the chance to redirect the page.
                /// This section warns the user, if Google Maps is detected on the system, that there may be unexpected behavior.
                if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
                    Section {
                            HStack {
                                Image(systemName: "exclamationmark.bubble.fill")
                                    .font(.largeTitle)
                                Text("Rerouter may not work as intended with Google Maps installed.\nTap for more information.")
                            }
                            .padding(.vertical, 6)
                            .foregroundColor(Color("warnTxt"))
                            .multilineTextAlignment(.leading)
                            .onTapGesture(perform: {
                                showMaps = true
                            })
                            .listRowBackground(Color("warnBkg"))
                    }.sheet(isPresented: $showMaps, content: {
                        MapWarningModal(showMapWarningModal: $showMaps)
                    })
                }
                Section {
                    /// Present instructions to enable the Rerouter extension.
                    Button(action: {
                        showExtension = true
                    }) {
                        Label {
                            Text("Enable Extension")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "puzzlepiece.extension.fill")
                                .foregroundColor(.accentColor)
                        }
                    }.sheet(
                        isPresented: self.$showExtension
                    ) {
                        ExtensionModal(showExtensionModal: $showExtension)
                    }
                    
                    /// Present Rerouter's privacy policy.
                    Button(action: {
                        showPrivacy = true
                    }) {
                        Label {
                            Text("Privacy Policy")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "hand.raised.fill")
                                .foregroundColor(.accentColor)
                        }
                    }.sheet(
                        isPresented: self.$showPrivacy
                    ) {
                        PrivacyModal(showPrivacyModal: $showPrivacy)
                    }
                    
                    /// Navigate to the About page.
                    NavigationLink(destination: AboutView()) {
                        Label {
                            Text("About")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                }
                
                Section {
                    Toggle("Reroute links manually", isOn: $isManual)
                        .tint(.accentColor)
                }
            }.navigationTitle("Rerouter")
        }.navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
