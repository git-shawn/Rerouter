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
                                Image(systemName: "exclamationmark.bubble")
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
                            Image(systemName: "puzzlepiece.extension")
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
                            Image(systemName: "hand.raised")
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
                            Image(systemName: "info.circle")
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                }
                
                Section {
                    Toggle("Enable manual rerouting", isOn: $isManual)
                        .tint(.accentColor)
                        .listRowSeparator(.hidden)
                    Text("You will be asked each time before Rerouter attempts to open a link in Maps. If you decline, you won't be asked again while on that page.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }.navigationTitle("Rerouter")
        }.navigationViewStyle(.stack)
        .withHostingWindow { window in
            #if targetEnvironment(macCatalyst)
            if let titlebar = window?.windowScene?.titlebar {
                titlebar.titleVisibility = .hidden
                titlebar.toolbar = nil
            }
            #endif
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Hide titlebar on macOS
// From John at https://stackoverflow.com/a/65243349

extension View {
    fileprivate func withHostingWindow(_ callback: @escaping (UIWindow?) -> Void) -> some View {
        self.background(HostingWindowFinder(callback: callback))
    }
}

fileprivate struct HostingWindowFinder: UIViewRepresentable {
    var callback: (UIWindow?) -> ()

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
