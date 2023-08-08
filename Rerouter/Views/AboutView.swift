//
//  AboutView.swift
//  Rerouter
//
//  Created by Shawn Davis on 2/4/23.
//

import SwiftUI
import StoreKit

struct AboutView: View {
    var body: some View {
        Form {
            Section {
                Link(destination: URL(string: "mailto:contact@fromshawn.dev")!, label: {
                    Label(title: {
                        Text("Email the Developer")
                            .foregroundColor(.primary)
                    }, icon: {
                        Image(systemName: "envelope.fill")
                    })
                    .labelStyle(ColorfulIconLabelStyle(color: .accentColor))
                })
                ShareLink(item: URL(string: "https://www.fromshawn.dev/rerouter")!, label: {
                    Label(title: {
                        Text("Share Rerouter")
                            .foregroundColor(.primary)
                    }, icon: {
                        Image(systemName: "square.and.arrow.up.fill")
                    })
                    .labelStyle(ColorfulIconLabelStyle(color: .accentColor))
                })
                TipButton()
            }
            
            Section {
                Link(destination: URL(string: "https://github.com/git-shawn/Rerouter")!, label: {
                    Label(title: {
                        Text("Source Code")
                            .foregroundColor(.primary)
                    }, icon: {
                        Image(systemName: "curlybraces.square.fill")
                    })
                    .labelStyle(ColorfulIconLabelStyle(color: .accentColor))
                })
                Link(destination: URL(string: "https://testflight.apple.com/join/gQHgloIz")!, label: {
                    Label(title: {
                        Text("Join the Beta")
                            .foregroundColor(.primary)
                    }, icon: {
                        Image(systemName: "wrench.and.screwdriver.fill")
                    })
                    .labelStyle(ColorfulIconLabelStyle(color: .accentColor))
                })
            }
            
            Section(content: {}, footer: {
                VStack(alignment: .center) {
                    Text("Rerouter is not affiliated with Google Maps")
                    Text("Made with \(Image(systemName: "heart")) in Southern Illinois")
                }
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            })
        }
        .navigationTitle("About")
#if targetEnvironment(macCatalyst)
        .environment(\.defaultMinListRowHeight, 42)
#endif
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
