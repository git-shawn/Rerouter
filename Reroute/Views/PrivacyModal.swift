//
//  PrivacyModal.swift
//  Rerouter
//
//  Created by Shawn Davis on 10/6/21.
//

import SwiftUI

struct PrivacyModal: View {
    
    var body: some View {
        ScrollView {
            VStack() {
                Text("Privacy Policy")
                    .font(.headline)
                    .padding(.top)
                HStack() {
                    Spacer()
                    Image(systemName: "hand.raised.square.fill")
                      .resizable()
                      .accessibilityHidden(true)
                      .scaledToFit()
                      .frame(width: 90, height: 90)
                      .foregroundColor(.accentColor)
                    Spacer()
                }.padding(.bottom)
                Text("Rerouter does not contain any trackers or loggers, and does not collect any user information. \n\nAdditionally, Rerouter will never add tracking via an update. Rerouter performs all processing on your device. That means Rerouter never shares your browsing information with a person, company, or server.")
            }
        }
        .padding(.horizontal, 20)
        .navigationBarTitle(Text("Privacy Policy"), displayMode: .large)
    }
}

struct PrivacyModal_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyModal()
    }
}
