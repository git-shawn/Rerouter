//
//  FeedbackView.swift
//  Rerouter
//
//  Created by Shawn Davis on 8/19/23.
//

import SwiftUI
import OSLog

struct FeedbackView: View {
    
    var body: some View {
        WebView(url: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfasGyOQ5lhw7S8niZ8PJgYFub-e4lRQJQrRmb2cehzjRC8jA/viewform")!)
            .ignoresSafeArea()
            .navigationTitle("Feedback")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.light)
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FeedbackView()
        }
    }
}
