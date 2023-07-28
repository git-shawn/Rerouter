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
    @State var routeQuery: String = ""
    @State var conversionError: Error? = nil
    
    var body: some View {
        NavigationStack {
            Form {
                /// Google Maps takes uses Universal Links to redirect web visitors to their app.
                /// iOS prioritizes Universal Links (understandably), so we likely won't even get the chance to redirect the page.
                /// This section warns the user, if Google Maps is detected on the system, that there may be unexpected behavior.
                if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
                    Section {
                        HStack {
                            Image(systemName: "exclamationmark.bubble")
                                .font(.largeTitle)
                            Text("Rerouter may not work as intended with Google Maps installed.")
                        }
                        .padding(.vertical, 6)
                        .foregroundColor(Color("warnTxt"))
                        .multilineTextAlignment(.leading)
                        .listRowBackground(Color("warnBkg"))
                    }
                }
                
                Section(content: {
                    HStack {
                        TextField(text: $routeQuery, label: {
                            Label("Enter a Link to Reroute", systemImage: "map.circle")
                        })
                        .onSubmit {
                            Task {
                                await convertURL()
                            }
                        }
                        .submitLabel(.done)
                        .keyboardType(.URL)
                        .toolbar {
                            ToolbarItem(placement: .keyboard, content: {
                                if UIPasteboard.general.hasURLs {
                                    Button("Paste URL", action: {
                                        routeQuery = UIPasteboard.general.url?.absoluteString ?? ""
                                    })
                                    Spacer()
                                }
                            })
                        }
                        if !routeQuery.isEmpty {
                            Button(action: {
                                routeQuery = ""
                            }, label: {
                                Label("Clear", systemImage: "x.circle.fill")
                                    .imageScale(.large)
                                    .labelStyle(.iconOnly)
                                    .foregroundColor(.gray)
                                    .opacity(0.5)
                            }).buttonStyle(.borderless)
                        }
                    }
                }, footer: {
                    Text("Paste a Google Maps URL to open in the default Maps app.")
                })
                Section {
                    NavigationLink(destination: {
                        GuideView()
                    }, label: {
                        Label("Getting Started", systemImage: "flag.checkered")
                            .labelStyle(ColorfulIconLabelStyle(color: .accentColor))
                    })
                    NavigationLink(destination: {
                        PrivacyView()
                    }, label: {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .accentColor))
                    })
                    NavigationLink(destination: {
                        AboutView()
                    }, label: {
                        Label("About Rerouter", systemImage: "info.bubble.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .accentColor))
                    })
                }
            }
            .toolbar(content: {
                Spacer()
            })
#if targetEnvironment(macCatalyst)
            .environment(\.defaultMinListRowHeight, 42)
#else
            .navigationTitle("Rerouter")
#endif
        }
        .errorAlert(error: $conversionError)
    }
    
    func convertURL() async {
        if let routeURL = URL(string: routeQuery) {
            let expandedURL = await routeURL.expand()
            let newURL = JSBridge().convertURL(text: expandedURL.absoluteString)
            if (newURL != nil) {
                await UIApplication.shared.open(URL(string: newURL!)!) { success in
                    if !success {
                        conversionError = .urlFailed
                    }
                }
            } else {
                conversionError = .routingError
            }
        } else {
            conversionError = .invalidURL
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
