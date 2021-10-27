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
    var images = ["safext1", "safext2", "safext3", "safext4", "safext5"]
    
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
                                Label("Open the Settings App", systemImage: "1.circle")
                                Label("Tap Safari", systemImage: "2.circle")
                                Label("Tap Extensions", systemImage: "3.circle")
                                Label("Tap Rerouter", systemImage: "4.circle")
                                Label("Turn Rerouter On", systemImage: "5.circle")
                            }
                            HStack() {
                                Label("Allow \"google.com\"", systemImage: "6.circle")
                                Spacer()
                                Button(action: {
                                    self.showSheet = true
                                }) {
                                    Text("Why?")
                                        .foregroundColor(.accentColor)
                                }.sheet(
                                    isPresented: self.$showSheet
                                ) { ScrollView{
                                    VStack(alignment: .leading, spacing: 20) {
                                    Text("Why should I allow access to google.com?")
                                        .font(.system(size: 32, weight: .bold))
                                    Text("Rerouter works by extracting the URL from the webpage and converting it into a URL that can be opened in Apple Maps. Rerouter then 'reroutes' the webpage to this new URL. Allowing \"google.com\" access makes this process convenient and automatic.\n\nGiving an extension the ability to modify webpages that you visit can be risky business, so Safari checks to make sure you're serious before sharing that information.\n\nRerouter may not work correctly, or at all, without this permission.\n\nYou can be confident knowing no funny business is going on. Rerouter's privacy policy explicitly states that all URLs are converted on-device and that this app contains no loggers, trackers, etc.")
                                    }.padding(.horizontal, 20)
                                            .padding(.top, 20)
                                    }
                                }
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
        }
    }
}

struct ExtensionModal_Previews: PreviewProvider {
    @State static private var showExtensionModal = true
    static var previews: some View {
        ExtensionModal(showExtensionModal: $showExtensionModal)
    }
}
