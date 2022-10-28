//
//  AboutView.swift
//  Rerouter
//
//  Created by Shawn Davis on 10/28/21.
//

import SwiftUI

struct AboutView: View {
    @State var hasPurchased: Bool = false
    
    var body: some View {
        List {
            Section {
                HStack(alignment: .center, spacing: 20) {
                    #if targetEnvironment(macCatalyst)
                    Image("appIconAbout-Mac")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 124, height: 124)
                    #else
                    Image("appIconAbout")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 114, height: 114)
                        .cornerRadius(20)
                    #endif
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Rerouter!")
                            .font(.title)
                            .bold()
                        Text("© 2022 Shawn Davis")
                            .font(.footnote)
                        Text("Made with \(Image(systemName: "heart")) in Montana")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            }.listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            Section {
                Link(destination: URL(string: "https://github.com/git-shawn/Rerouter")!) {
                    Label {
                        Text("Source Code")
                            .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: "chevron.left.forwardslash.chevron.right")
                            .foregroundColor(.accentColor)
                    }
                }
            }
            Section {
                Link(destination: URL(string: "mailto:contact@fromshawn.dev")!) {
                    Label {
                        Text("Contact")
                            .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: "envelope")
                            .foregroundColor(.accentColor)
                    }
                }
//                if #available(iOS 16.0, *) {
//                    ShareLink(item: "https://fromshawn.dev/rerouter.html", preview: SharePreview("Rerouter", image: Image("appIconAbout"))) {
//                        Label {
//                             Text("Share Rerouter")
//                                 .foregroundColor(.primary)
//                         } icon: {
//                             Image(systemName: "square.and.arrow.up.fill")
//                                 .foregroundColor(.accentColor)
//                         }
//                     }
//                } else {
                    Button(action: {
                        showShareSheet(with: [URL(string: "https://fromshawn.dev/rerouter.html")!])
                    }) {
                        Label {
                            Text("Share Rerouter")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.accentColor)
                        }
                    }
//                }
                Button(action: {
                    StoreManager.shared.leaveTip()
                }) {
                    Label {
                        Text("Buy Me a Coffee")
                            .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: "heart")
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .navigationBarTitle("About", displayMode: .large)
        .onReceive(StoreManager.shared.purchasePublisher) { value in
            switch value {
            case .purchased:
                hasPurchased = true
            case .restored:
                hasPurchased = true
            case .failed:
                hasPurchased = false
            case .deferred:
                hasPurchased = false
            case .purchasing:
                hasPurchased = false
            case .restoreComplete:
                hasPurchased = true
            case .noneToRestore:
                hasPurchased = false
            }
        }
        .alert(isPresented: $hasPurchased) {
            Alert(
                title: Text("Thank You!"),
                message: Text("Your support means the world to me!"),
                dismissButton: .default(Text("Close"))
            )
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
