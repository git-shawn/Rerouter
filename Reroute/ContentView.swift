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
    
    var body: some View {
        NavigationView {
            List {
                /// Google Maps takes uses Universal Links to redirect web visitors to their app.
                /// iOS prioritizes Universal Links (understandably), so we likely won't even get the chance to redirect the page.
                /// This section warns the user, if Google Maps is detected on the system, that there may be unexpected behavior.
                if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
                    Section {
                        VStack(alignment: .center) {
                            Group {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.largeTitle)
                                    Text("Rerouter may not work as intended with Google Maps installed.")
                                }
                            }.padding()
                            .foregroundColor(Color("warnTxt"))
                            .multilineTextAlignment(.leading)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundColor(Color("warnBkg"))
                            )
                        }.listRowBackground(Color.clear)
                        .frame(maxWidth: .infinity)
                    }
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
                    
                    /// Present instructions on how to use Rerouter.
                    Button(action: {
                        showGuide = true
                    }) {
                        Label {
                            Text("How to Use Rerouter")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "location.circle.fill")
                                .foregroundColor(.accentColor)
                        }
                    }.sheet(
                        isPresented: self.$showGuide
                    ) {
                        GuideModal(showGuideModal: $showGuide)
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
                    
                }
                Section {
                    
                    /// Navigate to the Preferences page.
                    NavigationLink(destination: PreferencesView()) {
                        Label {
                            Text("Preferences")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "text.badge.checkmark")
                                .foregroundColor(.accentColor)
                        }
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
            }.navigationTitle("Rerouter")
        }.navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
