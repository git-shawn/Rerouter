//
//  ExtensionModal.swift
//  Rerouter
//
//  Created by Shawn Davis on 10/6/21.
//

import SwiftUI

struct GuideModal: View {
    @State private var showSheet: Bool = false
    @State var index = 0
    var images = ["use1", "use2", "use3"]
    
    var body: some View {
        ScrollView {
            HStack() {
                Spacer()
                VStack(alignment: .leading, spacing: 20) {
                    HStack{
                        Spacer()
                        VStack() {
                            Text("How to Use Rerouter")
                                .font(.headline)
                                .padding(.top, 10)
                            InlinePhotoView(index: $index, images: images)
                                .frame(maxHeight: 400)
                        }
                        Spacer()
                    }.padding(10)
                    Group {
                        Group {
                            Label("Search for a Destination", systemImage: "1.circle")
                            Label("Tap Directions", systemImage: "2.circle")
                            Label("Tap Open", systemImage: "3.circle")
                            Text("\nThat's it! 🎉\n\nRerouting is automatic, and you may not need to even select \"Open\" after the first time going forward.")
                        }.font(.title3)
                        
                    }.padding(.horizontal, 20)
                }
            }.frame(maxWidth: 533)
            Spacer()
        }
        .navigationBarTitle(Text("Safari Extension"), displayMode: .large)
    }
}

struct UseModal_Previews: PreviewProvider {
    static var previews: some View {
        GuideModal()
            
            
    }
}
