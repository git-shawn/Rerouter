//
//  InlinePhotoView.swift
//  QR Pop (iOS)
//
//  Created by Shawn Davis on 10/4/21.
//

import SwiftUI
import UIKit

struct InlinePhotoView: View {
    @Binding var index: Int
    var images: Array<String>
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        PagingView(index: $index.animation(), maxIndex: images.count - 1) {
            ForEach(self.images, id: \.self) { imageName in
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .brightness(colorScheme == .dark ? 0.02 : -0.02)
            }
        }
        .aspectRatio(4/3, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(RoundedRectangle(cornerRadius: 15)
                    .stroke(.quaternary, lineWidth: 1))
    }
}

struct PagingView<Content>: View where Content: View {

    @Binding var index: Int
    let maxIndex: Int
    let content: () -> Content

    @State private var offset = CGFloat.zero
    @State private var dragging = false

    init(index: Binding<Int>, maxIndex: Int, @ViewBuilder content: @escaping () -> Content) {
        self._index = index
        self.maxIndex = maxIndex
        self.content = content
    }
    
    #if targetEnvironment(macCatalyst)
    @State private var backHover = false
    @State private var nextHover = false
    #endif

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        self.content()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    }
                }
                .content.offset(x: self.offset(in: geometry), y: 0)
                .frame(width: geometry.size.width, alignment: .leading)
                .gesture(
                    DragGesture().onChanged { value in
                        self.dragging = true
                        self.offset = -CGFloat(self.index) * geometry.size.width + value.translation.width
                    }
                    .onEnded { value in
                        let predictedEndOffset = -CGFloat(self.index) * geometry.size.width + value.predictedEndTranslation.width
                        let predictedIndex = Int(round(predictedEndOffset / -geometry.size.width))
                        self.index = self.clampedIndex(from: predictedIndex)
                        withAnimation(.easeOut) {
                            self.dragging = false
                        }
                    }
                )
                #if targetEnvironment(macCatalyst)
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        Button(action: {
                            if (index > 0) {
                                index -= 1;
                            } else {
                                index = maxIndex;
                            }
                        }, label: {
                            Label("Back", systemImage: "arrow.backward.circle.fill")
                                .font(.system(size: 48))
                                .symbolRenderingMode(.hierarchical)
                                .labelStyle(.iconOnly)
                        })
                            .foregroundColor(.primary)
                            .opacity(backHover ? 1 : 0.3)
                            .onHover(perform: {hovering in
                                backHover = hovering
                            })
                        Spacer()
                        Button(action: {
                            if (index < maxIndex) {
                                index += 1;
                            } else {
                                index = 0;
                            }
                        }, label: {
                            Label("Forward", systemImage: "arrow.forward.circle.fill")
                                .font(.system(size: 48))
                                .symbolRenderingMode(.hierarchical)
                                .labelStyle(.iconOnly)
                        })
                            .foregroundColor(.primary)
                            .opacity(nextHover ? 1 : 0.3)
                            .onHover(perform: {hovering in
                                nextHover = hovering
                            })
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    Spacer()
                }
                #endif
            }
            .clipped()

            PageControl(index: $index, maxIndex: maxIndex)
        }
    }

    func offset(in geometry: GeometryProxy) -> CGFloat {
        if self.dragging {
            return max(min(self.offset, 0), -CGFloat(self.maxIndex) * geometry.size.width)
        } else {
            return -CGFloat(self.index) * geometry.size.width
        }
    }

    func clampedIndex(from predictedIndex: Int) -> Int {
        let newIndex = min(max(predictedIndex, self.index - 1), self.index + 1)
        guard newIndex >= 0 else { return 0 }
        guard newIndex <= maxIndex else { return maxIndex }
        return newIndex
    }
}

struct PageControl: View {
    @Binding var index: Int
    let maxIndex: Int
    #if targetEnvironment(macCatalyst)
    let circleColor: Color = .primary
    #else
    let circleColor: Color = .accentColor
    #endif

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0...maxIndex, id: \.self) { index in
                Circle()
                    .fill(index == self.index ? circleColor : Color.gray)
                    .frame(width: 8, height: 8)
                    .opacity(0.9)
            }
        }
        .padding(15)
    }
}
