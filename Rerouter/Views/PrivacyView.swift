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
                GroupBox(label:
                            Label("TLDR", systemImage: "text.bubble")
                ) {
                    Text("Rerouter itself doesn't collect any data. Depending on your settings, Apple may. Outbound links probably will. Enjoy!")
                }
                
                Text("""
Rerouter ("the app") performs all processing locally, on your device. Any data collected or created by the app is never shared with me or any third parties.
  
If you have enabled "Share With App Developers" in the "Analytics & Improvements" section of your device's settings then anonymous data may be collected by Apple, Inc. ("Apple") and shared with me. You're welcome to disable this at any time. Please review Apple's [App Analytics Privacy Policy](https://www.apple.com/legal/privacy/data/en/app-analytics/) for more information.
  
Additionally, I have included links on this app for your use and reference, including the "Submit Feedback" feature. I am not responsible for the privacy policies on these websites. You should be aware that the privacy policies of these websites may differ from my own.
  
Any data you willfully and knowingly share, such as submitted data via the aforementioned feedback form or direct email correspondence with me, may be retained.
  
This policy is effective as of the date posted above and will remain in effect except with respect to any changes in its provisions in the future, which will be in effect immediately after being posted on this page.
  
I reserve the right to update or change this privacy policy at any time. You should check this privacy policy periodically. If any material changes are made a prominent notice will be placed within this app.
  
For any questions, comments, or concerns regarding this policy, please send me an email to [contact@fromshawn.dev](mailto:contact@fromshawn.dev).
""")
                
                Text("Last updated August 27, 2023")
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
