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
    @State private var showGuide: Bool = false
    @State var hasPurchased: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
                    Section {
                        VStack(alignment: .center) {
                            Group {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.largeTitle)
                                    Text("Rerouter will not work as intended with Google Maps installed.")
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
                    
                    Button(action: {
                        showGuide = true
                    }) {
                        Label {
                            Text("How to Use Rerouter")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "map.fill")
                                .foregroundColor(.accentColor)
                        }
                    }.sheet(
                        isPresented: self.$showGuide
                    ) {
                        GuideModal(showGuideModal: $showGuide)
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
                        PrivacyModal(showPrivacyModal: $showPrivacy)
                    }
                    
                }
                Section {
                    NavigationLink(destination: PreferencesView()) {
                        Label {
                            Text("Preferences")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "text.badge.checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                Section {
                    Link(destination: URL(string: "mailto:contact@fromshawn.dev")!) {
                        Label {
                            Text("Contact")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                    Button(action: {
                        showShareSheet(with: [URL(string: "https://fromshawn.dev/rerouter.html")!])
                    }) {
                        Label {
                            Text("Share Rerouter")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "square.and.arrow.up.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                    Button(action: {
                        StoreManager.shared.leaveTip()
                    }) {
                        Label {
                            Text("Buy Me a Coffee")
                                .foregroundColor(.primary)
                        } icon: {
                            Image("coffeeTip")
                                .resizable()
                                .scaledToFit()
                                .padding(3)
                                .foregroundColor(.accentColor)
                        }
                    }
                    Button(action: {
                        StoreManager.shared.requestReview()
                    }) {
                        Label {
                            Text("Leave a Review")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "star.bubble.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }.navigationTitle("Rerouter")
            .onReceive(StoreManager.shared.purchasePublisher) { value in
                switch value {
                case .purchased:
                    hasPurchased = true
                case .restored:
                    hasPurchased = true
                case .failed:
                    hasPurchased = false
                case .deferred:
                    hasPurchased = false
                case .purchasing:
                    hasPurchased = false
                case .restoreComplete:
                    hasPurchased = true
                case .noneToRestore:
                    hasPurchased = false
                }
            }
            .alert(isPresented: $hasPurchased) {
                Alert(
                    title: Text("Thank You!"),
                    message: Text("Your support means the world to me, and I'm so happy you're enjoying Rerouter. 😊"),
                    dismissButton: .default(Text("Close"))
                )
            }
        }.navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
