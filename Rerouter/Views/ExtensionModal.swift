//
//  ExtensionModal.swift
//  Rerouter
//
//  Created by Shawn Davis on 10/6/21.
//

import SwiftUI

struct ExtensionModal: View {
    @Binding var showExtensionModal: Bool
    @State private var showSheet: Bool = false
    @State var index = 0
#if targetEnvironment(macCatalyst)
    var images = ["catext1", "catext2", "catext3", "catext4", "catext5"]
#else
    var images = ["safext1", "safext2", "safext3", "safext4", "safext5"]
#endif
    
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
#if targetEnvironment(macCatalyst)
                                Label("Open Safari", systemImage: "1.circle")
                                Label("Select Safari > Settings from the Menu Bar", systemImage: "2.circle")
                                Label("Click on Extensions", systemImage: "3.circle")
                                Label("Click on Rerouter", systemImage: "4.circle")
                                Label("Turn Rerouter On", systemImage: "5.circle")
#else
                                Label("Open the Settings App", systemImage: "1.circle")
                                Label("Tap Safari", systemImage: "2.circle")
                                Label("Tap Extensions", systemImage: "3.circle")
                                Label("Tap Rerouter", systemImage: "4.circle")
                                Label("Turn Rerouter On", systemImage: "5.circle")
#endif
                            }
                            HStack() {
                                Label("Allow *All Websites*", systemImage: "6.circle")
                                Spacer()
                                Button(action: {
                                    self.showSheet = true
                                }) {
                                    Text("Why?")
                                        .foregroundColor(.accentColor)
                                }.sheet(
                                    isPresented: self.$showSheet
                                ) {
                                    NavigationView {
                                        ScrollView {
                                            VStack(alignment: .leading, spacing: 20) {
                                                Text("Why should I allow access to all websites")
                                                    .font(.system(size: 32, weight: .bold))
                                                Text("Rerouter works by intercepting requests to visit Google Maps, and *rerouting* you to Apple Maps instead on the fly. To accomplish that, Rerouter needs permission to see these requests as you make them.\n\nYou can be confident that there isn't any funny business happening behind the scenes. As the privacy policy explicitly states, all processing happens on your device. There are no trackers, no loggers, nothing.\n\nFor those more technical, you can even browse the source code yourself by tapping the link in the **About** page.")
                                            }.padding(.horizontal, 20)
                                                .padding(.top, 20)
                                                .navigationBarTitle(Text("Allowing Access"), displayMode: .inline)
                                                .toolbar(content: {
                                                    ToolbarItem(placement: .navigationBarTrailing, content: {
                                                        Button(action: {
                                                            showSheet = false
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
                            }
                        }.padding(.horizontal, 20)
                    }
                }.frame(maxWidth: 533)
                    .padding(.bottom)
                Spacer()
            }
            .navigationBarTitle(Text("Safari Extension"), displayMode: .inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        showExtensionModal = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color(UIColor.secondaryLabel), Color(UIColor.systemFill))
                            .font(.title2)
                            .accessibility(label: Text("Close"))
                    }
                })
            })
        }.navigationViewStyle(.stack)
    }
}

struct ExtensionModal_Previews: PreviewProvider {
    @State static private var showExtensionModal = true
    static var previews: some View {
        ExtensionModal(showExtensionModal: $showExtensionModal)
    }
}
