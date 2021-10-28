//
//  ExtensionModal.swift
//  Rerouter
//
//  Created by Shawn Davis on 10/6/21.
//

import SwiftUI

struct GuideModal: View {
    @Binding var showGuideModal: Bool
    @State private var showSheet: Bool = false
    @State var index = 0
    
    /// The automatic boolean is used to show different app instructions depending on if the user has automatic mode enabled or disabled.
    @AppStorage("automatic", store: UserDefaults(suiteName: "group.shwndvs.Rerouter")) var automatic: Bool = true
    
    /// Shown when automatic mode is true.
    var images = ["use1", "use2", "use3"]
    /// Shown when automatic mode is false.
    var altImages = ["use1", "use2", "use3alt"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack() {
                    Spacer()
                    VStack(alignment: .leading, spacing: 20) {
                        HStack{
                            Spacer()
                            VStack() {
                                InlinePhotoView(index: $index, images: (automatic ? images : altImages))
                                    .frame(maxHeight: 400)
                            }
                            Spacer()
                        }.padding(10)
                        Group {
                            Group {
                                Label("Search for a Destination", systemImage: "1.circle")
                                Label("Tap Directions", systemImage: "2.circle")
                                Label((automatic ? "Tap Open" : "Tap \"Open in Apple Maps\" via the extension."), systemImage: "3.circle")
                                Text((automatic ? "\nThat's it! 🎉\n\nIf you'd prefer more control, you can disable automatic rerouting in preferences." : "\nThat's it! 🎉\n\nIf you'd prefer rerouting happened automatically, you can enable that in preferences."))
                            }
                        }.padding(.horizontal, 20)
                    }
                }.frame(maxWidth: 533)
                Spacer()
            }
            .navigationBarTitle(Text("Safari Extension"), displayMode: .inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        showGuideModal = false
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

struct UseModal_Previews: PreviewProvider {
    @State static var showGuideModal = true
    static var previews: some View {
        GuideModal(showGuideModal: $showGuideModal)
            
            
    }
}
