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
            Text("""
Let's start with the basics: **I do not collect any information**. Period. No personal information, no private information, no analytic data—nothing.

That being said, if you consented to share app-specific analytic information with developers, Apple may collect anonymized usage data on my behalf. You can learn more about this in Apple's article on ["App Analytics & Privacy."](https://www.apple.com/legal/privacy/data/en/app-analytics/)

Additionally, if you chose to email me some information may be retained to facilitate that conversation. This data includes your email address as well as the contents of the email itself. My email, [contact@fromshawn.dev](contact@fromshawn.dev), also uses iCloud.

For my more technically inclined users, you're encouraged to verify all of these claims by perusing this app's publicly available [GitHub repository](https://github.com/git-shawn/rerouter). Of course, feel free to reach out to me with any further questions or comments.
""")
#if targetEnvironment(macCatalyst)
            .padding()
#else
            .padding(.bottom)
            .padding(.horizontal)
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
