//
//  ContentView.swift
//  Rerouter
//
//  Created by Shawn Davis on 10/6/21.
//

import SwiftUI
import OSLog
import StoreKit

/// Rerouter's initial view.
struct ContentView: View {
    @State var routeQuery: String = ""
    @State var conversionError: Error? = nil
    @State var showGuide: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
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
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
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
                                    .imageScale(.medium)
                                    .labelStyle(.iconOnly)
                                    .foregroundColor(.gray)
                                    .opacity(0.5)
                            })
                            .buttonStyle(.borderless)
                        }
                    }
                }, footer: {
                    Text("Paste a Google Maps URL to open in the default Maps app.")
                })
                
                Section {
                    Button(action: {
                        showGuide.toggle()
                    }, label: {
                        HStack {
                            Label("Setup Guide", systemImage: "flag.checkered")
                                .labelStyle(ColorfulIconLabelStyle(color: .accentColor))
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .opacity(0.5)
                                .bold()
                        }
                    })
                    .sheet(isPresented: $showGuide) {
                        NavigationView {
                            GuideView()
                                .navigationTitle("Setup Guide")
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    Button("Done", action: {
                                        showGuide = false
                                    })
                                }
                        }
                    }
                    
                    Link(destination: (
                        URL(string: "https://www.fromshawn.dev/rerouter/privacy-policy")!
                    ), label: {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .accentColor))
                    })
                    .buttonStyle(OutboundLinkButtonStyle())
                    
                    NavigationLink(destination: {
                        AboutView()
                    }, label: {
                        Label("About Rerouter", systemImage: "info.bubble.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .accentColor))
                    })
                }
                
                Section {
                    NavigationLink(
                        destination:
                            FeedbackView(),
                        label: {
                            Label(title: {
                                Text("Submit Feedback")
                                    .foregroundColor(.primary)
                            }, icon: {
                                Image(systemName: "megaphone.fill")
                            })
                            .labelStyle(ColorfulIconLabelStyle(color: .accentColor))
                        })
                }
            }
            .toolbar(content: {
                Spacer()
            })
            .safeAreaInset(edge: .bottom, alignment: .center) {
                GMapsDetective()
            }
            
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
            if let reroutedURL = JSBridge().convertURL(text: expandedURL.absoluteString),
               let finalURL = URL(string: reroutedURL) {
                
                Logger.view.info("ContentView: URL converted to \(reroutedURL)")
                await UIApplication.shared.open(finalURL) { success in
                    if !success {
                        Logger.view.error("ContentView: Could not open rerouted URL")
                        conversionError = .urlFailed
                    }
                }
            } else {
                Logger.view.error("ContentView: Could not reroute URL")
                conversionError = .routingError
            }
        } else {
            if !routeQuery.isEmpty {
                Logger.view.notice("ContentView: Invalid URL submitted")
                conversionError = .invalidURL
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
