//
//  PrivacyModal.swift
//  Rerouter
//
//  Created by Shawn Davis on 10/6/21.
//

import SwiftUI

struct MapWarningModal: View {
    @Binding var showMapWarningModal: Bool
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Why Can't I Have Google Maps Installed?")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.leading)
                    Text("Apps, like Google Maps, sometimes use a system Apple calls **Universal Links**. Universal Links, created in iOS 9, allow apps to seamlessly and securely connect their website with their app.\n\nAs far as I can tell, there is no way to disrupt another app's Universal Link. Google's own Maps app will always have priority over other apps, like Rerouter, when interacting with Google Maps links because of the Universal Links system.\n\n**In short, there is no way to reliably force Google Maps links to open in Apple Maps when the Google Maps app is installed.**\n\nYou can read more about this on [Apple's Website](https://developer.apple.com/ios/universal-links/).")
                }
            }
            .padding(.horizontal, 20)
            .navigationBarTitle(Text("Rerouter"), displayMode: .inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        showMapWarningModal = false
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

struct MapWarningModal_Previews: PreviewProvider {
    @State static var showPrivacy = false
    static var previews: some View {
        PrivacyModal(showPrivacyModal: $showPrivacy)
    }
}
