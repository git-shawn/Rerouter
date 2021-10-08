//
//  ContentView.swift
//  Rerouter
//
//  Created by Shawn Davis on 10/6/21.
//

import SwiftUI

struct ContentView: View {
    @State private var showExtension: Bool = false
    @State private var showPrivacy: Bool = false
    
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
