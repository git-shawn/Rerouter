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
            VStack(alignment: .leading, spacing: 15) {
                
                Text("""
Rerouter doesn't collect, store, or transmit any of your data in any way.

However, if you've enabled "Share With App Developers" in the "Analytics & Improvements" section of your device's settings then anonymous data may be collected by Apple and shared with me. You're welcome to disable this at any time. Please review Apple's [App Analytics Privacy Policy](https://www.apple.com/legal/privacy/data/en/app-analytics/) for more information.

Additionally, if you choose to "Submit Feedback" usage and analytic data may be collected by Google. Submitting feedback is not necessary to use and enjoy Rerouter. Please review [Google Privacy Policy](https://policies.google.com/privacy) for more information.

Finally, any data you willfully and knowingly share, such as submitted data via the aforementioned feedback form or direct email correspondence with the developer, may be retained.

If you have any questions at all feel free to email me any time at  contact@fromshawn.dev. I'll try to respond as quickly as I can.

Thank you so much for using Rerouter.
""")
                
                Text("Last updated August 19, 2023")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
            }
            .frame(maxWidth: .infinity)
#if targetEnvironment(macCatalyst)
            .scenePadding()
#else
            .scenePadding(.bottom)
            .scenePadding(.horizontal)
#endif
        }
        .navigationTitle("Privacy Policy")
    }
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PrivacyView()
        }
    }
}
