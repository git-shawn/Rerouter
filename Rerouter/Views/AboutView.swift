//
//  AboutView.swift
//  Rerouter
//
//  Created by Shawn Davis on 2/4/23.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        Form {
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
            }
            Section {
                Link(destination: URL(string: "mailto:contact@fromshawn.dev")!, label: {
                    Label(title: {
                        Text("Contact Me")
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
                Link(destination: URL(string: "https://www.fromshawn.dev/apps")!, label: {
                    Label(title: {
                        Text("More Apps By Me")
                            .foregroundColor(.primary)
                    }, icon: {
                        Image(systemName: "plus.square.fill.on.square.fill")
                    })
                    .labelStyle(ColorfulIconLabelStyle(color: .accentColor))
                })
                Button(action: {
                    StoreManager.shared.leaveTip()
                }, label: {
                    Label(title: {
                        Text("Buy Me a Coffee")
                            .foregroundColor(.primary)
                    }, icon: {
                        Image(systemName: "mug.fill")
                    })
                    .labelStyle(ColorfulIconLabelStyle(color: .accentColor))
                })
            }
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
