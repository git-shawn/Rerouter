//
//  PrivacyModal.swift
//  Rerouter
//
//  Created by Shawn Davis on 10/6/21.
//

import SwiftUI

struct PrivacyModal: View {
    @Binding var showPrivacyModal: Bool
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack() {
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
                    Text("Rerouter does not contain any trackers or loggers, and does not collect any user information. \n\nAdditionally, Rerouter will **never** add tracking via an update. Rerouter performs all processing on your device. That means Rerouter never shares your browsing information with a person, company, or server.")
                }
            }
            .padding(.horizontal, 20)
            .navigationBarTitle(Text("Privacy Policy"), displayMode: .inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        showPrivacyModal = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color(UIColor.secondaryLabel), Color(UIColor.systemFill))
                            .font(.title2)
                            .accessibility(label: Text("Close"))
                    }
                })
            })
        }
    }
}

struct PrivacyModal_Previews: PreviewProvider {
    @State static var showPrivacy = false
    static var previews: some View {
        PrivacyModal(showPrivacyModal: $showPrivacy)
    }
}
