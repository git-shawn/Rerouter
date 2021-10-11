//
//  ContentView.swift
//  Rerouter
//
//  Created by Shawn Davis on 10/6/21.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @State private var showExtension: Bool = false
    @State private var showPrivacy: Bool = false
    @State private var showShare: Bool = false
    private var sawRatingRequest: Bool = UserDefaults.standard.bool(forKey: "sawRatingRequest")
    
    var body: some View {
        NavigationView {
            List {
                Section {
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
                        ExtensionModal()
                    }
                    
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
                        PrivacyModal()
                    }
                    
                }
                Section {
                    Link(destination: URL(string: "mailto:shawnios@outlook.com")!) {
                        Label {
                            Text("Contact")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                    Button(action: {
                        self.showShare = true
                    }) {
                        Label {
                            Text("Share Rerouter")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "square.and.arrow.up.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .sheet(isPresented: $showShare, onDismiss: {
                        // If they shared the app, request a review. If they've seen the request before, don't show it again.
                        if (sawRatingRequest == false) {
                            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                                SKStoreReviewController.requestReview(in: scene)
                                UserDefaults.standard.set(true, forKey: "sawRatingRequest")
                            }
                        }
                    }, content: {
                        ZStack {
                        ActivityViewController(activityItems: [URL(string: "https://fromshawn.dev/rerouter.html")!])
                        }.background(.ultraThickMaterial)
                    })
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
