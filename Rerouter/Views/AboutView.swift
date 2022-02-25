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
                    Image("appIconAbout")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 114, height: 114)
                        .cornerRadius(20)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Rerouter")
                            .font(.title2)
                            .bold()
                        Text("© 2022 Shawn Davis")
                            .font(.subheadline)
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
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.accentColor)
                    }
                }
                Button(action: {
                    showShareSheet(with: [URL(string: "https://fromshawn.dev/rerouter.html")!])
                }) {
                    Label {
                        Text("Share Rerouter")
                            .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: "square.and.arrow.up.fill")
                            .foregroundColor(.accentColor)
                    }
                }
                Button(action: {
                    StoreManager.shared.leaveTip()
                }) {
                    Label {
                        Text("Buy Me a Coffee")
                            .foregroundColor(.primary)
                    } icon: {
                        Image("coffeeTip")
                            .resizable()
                            .scaledToFit()
                            .padding(3)
                            .foregroundColor(.accentColor)
                    }
                }
                Button(action: {
                    StoreManager.shared.requestReview()
                }) {
                    Label {
                        Text("Leave a Review")
                            .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: "star.bubble.fill")
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
