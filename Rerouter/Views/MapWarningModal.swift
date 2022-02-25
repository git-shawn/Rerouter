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
                    Text("Using Rerouter with Google Maps")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.leading)
                    Text("Apps, like Google Maps, sometimes use a system Apple calls **Universal Links**. Universal Links, created in iOS 9, allow apps to seamlessly and securely connect their website with their app.\n\nTo overcome this and use Rerouter with Google Maps installed, you'll need to **long press** on any Google Maps links and select **Open in Safari**. Once you've done that once, iOS will (for the most part) remember your decision.")
                    HStack {
                        Spacer()
                        Image("openSaf")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 350)
                            .padding()
                        Spacer()
                    }
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
