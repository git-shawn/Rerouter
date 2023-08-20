//
//  UIVideoPlayer.swift
//  Rerouter
//
//  Created by Shawn Davis on 7/30/23.
//

import SwiftUI
import AVKit
import UIKit

struct AVPlayerControllerRepresented : UIViewControllerRepresentable {
    var player : AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.updatesNowPlayingInfoCenter = false
#if !targetEnvironment(macCatalyst)
        controller.allowsVideoFrameAnalysis = false
#endif
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}
