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
    var images = ["use1", "use2", "use3"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack() {
                    Spacer()
                    VStack(alignment: .leading, spacing: 20) {
                        HStack{
                            Spacer()
                            VStack() {
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
                                Text("\nThat's it! 🎉\n\nBy default Rerouting is automatic, but you can chose to disable that feature on the preferences page. When automatic Rerouting is disabled, just press the \"Open in Apple Maps\" button in the Safari Extension instead.")
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
