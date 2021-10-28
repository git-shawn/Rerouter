//
//  PreferencesView.swift
//  Rerouter
//
//  Created by Shawn Davis on 10/27/21.
//

import SwiftUI

struct PreferencesView: View {
    
    /// Whether or not the extension should automatically redirect pages.
    @AppStorage("automatic", store: UserDefaults(suiteName: "group.shwndvs.Rerouter")) var automatic: Bool = true
    
    /// If automatic = true, this integer represents what kinds of pages Rerouter should redirect to Apple Maps.
    /// If 0, redirect only directions.
    /// If 1, redirect directions and search results.
    /// If 2, try to redirect everything.
    @AppStorage("openableLinks", store: UserDefaults(suiteName: "group.shwndvs.Rerouter")) var openableLinks: Int = 0
    
    var body: some View {
        Form {
            Toggle("Open in Maps Automatically?", isOn: $automatic)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                .onChange(of: automatic, perform: { value in
                    if !value {
                        openableLinks = 2
                    }
                })
            Picker("Use Rerouter for", selection: $openableLinks) {
                Text("Only Directions").tag(0)
                Text("Directions & Search Results").tag(1)
                Text("All Google Maps links").tag(2)
            }.disabled(!automatic)
        }
        .navigationBarTitle("Preferences", displayMode: .large)
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
