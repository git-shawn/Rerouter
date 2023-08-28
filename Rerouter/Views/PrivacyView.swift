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
Rerouter does not embed any third-party tracking or logging technologies nor does it retain or transmit any data.

**Analytics**
Rerouter does not perform any first-party data collection, including the collection of analytic data. If you previously agreed to share analytic data with developers then some anonymized data may be collected by Apple, Inc ("Apple") and shared with me. Please refer to Apple's [App Analytics Privacy Policy](https://www.apple.com/legal/privacy/data/en/app-analytics/) for more information.

**External Links**
For your use and reference, various third-party links may have been embedded into this application. I am not responsible for the privacy policies of these external services. Their privacy policies may differ from my own.

**Direct Communications**
If you choose to communicate with me directly, such as via email, then any information you share may be retained.

**Future Changes**
I reserve the right to review and update this privacy policy in the future as needed. You are encouraged to occasionally revisit this page to stay aware of modifications to this agreement.

Rest assured, this document will never allow for the collection of any data for, or concerning, advertising.

**Contact**
For any questions, feel free to contact me via email at contact@fromshawn.dev. I look forward to hearing from you.
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
