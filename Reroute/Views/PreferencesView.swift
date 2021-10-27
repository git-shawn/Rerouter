//
//  PreferencesView.swift
//  Rerouter
//
//  Created by Shawn Davis on 10/27/21.
//

import SwiftUI

struct PreferencesView: View {
    
    @AppStorage("automatic", store: UserDefaults(suiteName: "group.shwndvs.Rerouter")) var automatic: Bool = true
    
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
