//
//  GuideView.swift
//  Rerouter
//
//  Created by Shawn Davis on 3/10/23.
//

import SwiftUI
import Slideshow

struct Item: Identifiable {
    let id = UUID()
    let image: String
    let title: String
}
#if targetEnvironment(macCatalyst)
let items = [
    Item(image: "catext1", title: "first"),
    Item(image: "catext2", title: "second"),
    Item(image: "catext3", title: "third"),
    Item(image: "catext4", title: "fourth"),
    Item(image: "catext5", title: "fourth")
]
#else
let items = [
    Item(image: "safext1", title: "first"),
    Item(image: "safext2", title: "second"),
    Item(image: "safext3", title: "third"),
    Item(image: "safext4", title: "fourth"),
    Item(image: "safext5", title: "fourth")
]
#endif

struct GuideView: View {
    @State private var showAllowAllAlert: Bool = false
    var body: some View {
        ScrollView {
            Slideshow(items, spacing: 10, isWrap: true, autoScroll: .defaultActive) { item in
                itemView(item: item)
                    .frame(width: 350, height: 200)
                    .cornerRadius(16)
            }.frame(width: UIScreen.main.bounds.width, height: 200)
                .padding()
            VStack(alignment: .leading, spacing: 16) {
                // Instructions for macOS
#if targetEnvironment(macCatalyst)
                Group {
                    Label("Open the **Safari** app", systemImage: "safari")
                    Label("Select **Safari > Settings** from the menu bar", systemImage: "filemenu.and.cursorarrow")
                    Label("Select **Extensions**", systemImage: "puzzlepiece.extension")
                    Label("Select **Rerouter**", systemImage: "location.circle")
                    Label("Toggle Rerouter **on**", systemImage: "checkmark.circle")
                    Label("Enable **All Websites**", systemImage: "checkmark.circle.trianglebadge.exclamationmark")
                } .labelStyle(GettingStartedLabelStyle())
#else
                // Instructions for iOS
                Group {
                    Label("Open the **Settings** app", systemImage: "gear")
                    Label("Scroll down to **Safari**", systemImage: "safari")
                    Label("Select **Extensions**", systemImage: "puzzlepiece.extension")
                    Label("Select **Rerouter**", systemImage: "location.circle")
                    Label("Toggle Rerouter **on**", systemImage: "checkmark.circle")
                    Label("Enable **All Websites**", systemImage: "checkmark.circle.trianglebadge.exclamationmark")
                        .onTapGesture(perform: {
                            showAllowAllAlert = true
                        })
                        .popover(isPresented: $showAllowAllAlert, content: {
                            Text("Rerouter blah blah blah :(")
                                .padding()
                        })
                } .labelStyle(GettingStartedLabelStyle())
#endif
            }
            .padding()
        }
        .navigationTitle("Getting Started")
    }
    
    @ViewBuilder
    func itemView(item: Item) -> some View {
        ZStack {
            Image(item.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
        }
    }
}

struct GuideView_Previews: PreviewProvider {
    static var previews: some View {
        GuideView()
    }
}
