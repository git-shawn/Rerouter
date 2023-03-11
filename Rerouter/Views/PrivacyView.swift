//
//  PrivacyView.swift
//  Rerouter
//
//  Created by Shawn Davis on 2/4/23.
//

import SwiftUI

struct PrivacyView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            Image(systemName: "hand.raised.circle")
                .font(.system(size: 72))
                .foregroundColor(.accentColor)
                .padding(.vertical)
            Text("Rerouter does not contain any trackers or loggers and does not collect any user information. \n\n Additionally, Rerouter will **never** add tracking via an update. Rerouter performs all processing on your device. That means Rerouter never shares your browsing information with a person, company, or server.\n\nYou are encouraged to verify these claims by browsing the source code on [Github](https://github.com/git-shawn/Rerouter).")
                .padding(.bottom)
                .padding(.horizontal)
        }.navigationTitle("Privacy Policy")
    }
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView()
    }
}
