//
//  GuideView.swift
//  Rerouter
//
//  Created by Shawn Davis on 3/10/23.
//

import SwiftUI
import AVKit

struct GuideView: View {
    @State private var showAllowAllDisclaimer: Bool = false
#if targetEnvironment(macCatalyst)
    @State var avPlayer = AVPlayer(url: Bundle.main.url(forResource: "macSafExtSetup", withExtension: "mp4")!)
#else
    @State var avPlayer = AVPlayer(url: Bundle.main.url(forResource: "mobileSafExtSetup", withExtension: "mp4")!)
#endif
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomTrailing) {
                AVPlayerControllerRepresented(player: avPlayer)
                    .aspectRatio(16/9, contentMode: .fit)
                    .frame(maxWidth: 480)
                    .cornerRadius(15, antialiased: true)
                    .overlay {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(.gray, lineWidth: 2)
                    }
                    .onAppear {
                        avPlayer.seek(to: .zero)
                        avPlayer.play()
                    }
                Button(action: {
                    avPlayer.seek(to: .zero)
                    avPlayer.play()
                }, label: {
                    Label("Replay", systemImage: "arrow.counterclockwise")
                        .labelStyle(.iconOnly)
                        .foregroundColor(.primary)
                        .font(.headline)
                        .padding(7)
                        .background(
                            Circle()
                                .fill(.thickMaterial)
                                .shadow(radius: 3)
                        )
                        .padding()
                })
#if targetEnvironment(macCatalyst)
                .buttonStyle(.plain)
#endif
            }
            .padding()
#if targetEnvironment(macCatalyst)
            macGuide
#else
            iosGuide
#endif
            Spacer()
        }
        .sheet(isPresented: $showAllowAllDisclaimer) {
            allowAllDisclaimer
        }
    }
#if targetEnvironment(macCatalyst)
    var macGuide: some View {
        Grid(alignment: .leading, horizontalSpacing: 15, verticalSpacing: 15) {
            GridRow {
                Image(systemName: "safari")
                    .foregroundColor(.secondary)
                Text("Open the **Safari** app")
            }
            GridRow {
                Image(systemName: "filemenu.and.cursorarrow")
                    .foregroundColor(.secondary)
                Text("Select **Settings** from the menu bar")
            }
            GridRow {
                Image(systemName: "puzzlepiece.extension")
                    .foregroundColor(.secondary)
                Text("Select **Extensions**")
            }
            GridRow {
                Image(systemName: "location.circle")
                    .foregroundColor(.secondary)
                Text("Turn Rerouter **on**")
            }
            GridRow {
                Image(systemName: "lock.open")
                    .foregroundColor(.secondary)
                HStack(spacing: 15) {
                    Text("**Allow** on every websites")
                    Button(action: {
                        showAllowAllDisclaimer.toggle()
                    }, label: {
                        Label("More Info", systemImage: "info.circle.fill")
                            .labelStyle(.iconOnly)
                            .font(.body)
                    })
                    .buttonStyle(.plain)
                    .foregroundColor(.accentColor)
                }
            }
        }
        .font(.title3)
        .padding()
        .padding(.horizontal)
    }
    
#else
    
    var iosGuide: some View {
        Grid(alignment: .leading, horizontalSpacing: 15, verticalSpacing: 15) {
            GridRow {
                Image(systemName: "gear")
                    .foregroundColor(.secondary)
                Text("Open the **Settings** app")
            }
            GridRow {
                Image(systemName: "safari")
                    .foregroundColor(.secondary)
                Text("Select **Safari**")
            }
            GridRow {
                Image(systemName: "puzzlepiece.extension")
                    .foregroundColor(.secondary)
                Text("Select **Extensions**")
            }
            GridRow {
                Image(systemName: "location.circle")
                    .foregroundColor(.secondary)
                Text("Turn Rerouter **on**")
            }
            GridRow {
                Image(systemName: "lock.open")
                    .foregroundColor(.secondary)
                HStack(spacing: 15) {
                    Text("**Allow** all websites")
                    Button(action: {
                        showAllowAllDisclaimer.toggle()
                    }, label: {
                        Label("More Info", systemImage: "info.circle.fill")
                            .labelStyle(.iconOnly)
                            .font(.body)
                    })
                }
            }
        }
        .font(.title3)
        .padding()
        .padding(.horizontal)
    }
#endif
    
    var allowAllDisclaimer: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Rerouter needs permission to view the URL of **every** website you visit in order to function. Why?")
                    Text("Why Should I Allow All Websites?")
                        .font(.title)
                        .bold()
                    Text("Every time you visit a website, Rerouter will check the URL to see if it belongs to Google Maps. If it does, the app will begin the process of converting that URL then redirecting you.\n\nWhile it might seem easy to limit Rerouter's scope to just \"maps.google.com,\" Google Maps URLs take on a lot more forms than that. These URLs can appear as \"goo.gl,\" \"google.com/maps,\" and of course various unique countries like \"maps.google.de\" and \"google.co.jp/maps.\"\n\nWhile it would make the process a lot less **automatic**, you are always free to enable Rerouter on a per-website basis. Additionally, Rerouter can be easily activated and deactivated from within Safari.")
                    Text("What About My Privacy?")
                        .font(.title)
                        .bold()
                    Text("That's a great question, and one you should always ask before granting \"All Websites\" permission to an extension. Luckily, there's nothing to worry about here.\n\nRerouter is built with privacy in mind. All processing happens on your device and no data is collected by me—period. You can read more about this in Rerouter's Privacy Policy but the long and short of it is that Rerouter doesn't track you and it never will.\n\nFor those more technically inclined, you do not have to take my word for it. Rerouter is completely open-source. All code is avaialble for you to browse yourself [on Github](https://www.github.com/git-shawn/rerouter) at any time. Additionally, I'm always available [via email](mailto:contact@fromshawn.dev) for any questions.\n\nThank you for using Rerouter \(Image(systemName: "heart"))")
                }
                .padding()
            }
            .navigationTitle("Allow All Websites")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done", action: {
                    showAllowAllDisclaimer = false
                })
            }
        }
    }
}

struct GuideView_Previews: PreviewProvider {
    static var previews: some View {
        GuideView()
    }
}
