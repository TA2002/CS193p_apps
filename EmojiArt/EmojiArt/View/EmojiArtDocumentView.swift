//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Tarlan Askaruly on 18.04.2021.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    @State var selectedEmojis: [EmojiArt.Emoji] = []
    
    var body: some View {
        VStack {
            ScrollView(.horizontal){
                HStack {
                    ForEach(EmojiArtDocument.pallete.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: self.defaultEmojiSize))
                            .onDrag() {
                                return NSItemProvider(object: emoji as NSString)
                            }
                    }
                }
            }.gesture(self.tapGesture())
            GeometryReader { geometry in
                ZStack {
                    Color.white.overlay(
                        OptionalImage(uiImage: self.document.backgroundImage)
                            .scaleEffect(zoomScale)
                            .offset(panOffset)
                    )
                    .onTapGesture {
                        selectedEmojis = []
                    }
                    ForEach(0..<document.emojis.count, id: \.self) { index in
                        EmojiWithSelection(emoji: document.emojis[index], for: geometry.size)
                            .offset(selectedEmojis.contains(matching: document.emojis[index]) ? dragOffset : .zero)
                            .gesture(dragGesture())
                        //.scaleEffect(selectedEmojis.contains(matching: document.emojis[index]) ? selectedZoomScale : 1)
                            //.scaleEffect(selectedEmojis.contains(matching: document.emojis[index]) ? pinchScale : .zero)
                            
                    }
                }
                    .gesture(self.panGesture())
                    .gesture(self.zoomGesture())
                    .gesture(self.doubleTapToZoom(in: geometry.size))
                    .clipped()
                    
                    
                    .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                        var location = geometry.convert(location, from: .global)
                        location = CGPoint(x: location.x - geometry.size.width / 2, y: location.y - geometry.size.height / 2)
                        location = CGPoint(x: location.x - panOffset.width, y: location.y - panOffset.height)
                        location = CGPoint(x: location.x / self.zoomScale, y: location.y / self.zoomScale)
                        return self.drop(providers: providers, at: location)
                    }
            }
        }
            .ignoresSafeArea(edges: [.horizontal, .bottom])
            .onAppear() {
                //steadyStatePanOffsetForEmojis = [CGSize](repeating: .zero, count: document.emojis.count)
            }
    }
    
    
    
    @State private var dragOffset: CGSize = .zero
    
    private func dragGesture() -> some Gesture {
        DragGesture()
            .onChanged({ value in
                self.dragOffset = value.translation
            })
            .onEnded({ value in
                for selectedEmoji in selectedEmojis {
                    document.moveEmoji(selectedEmoji, by: value.translation)
                }
                dragOffset = .zero
            })
    }
    
    private func tapGesture() -> some Gesture {
        TapGesture(count: 1)
            .onEnded {
                selectedEmojis = []
            }
    }
    
    @ViewBuilder
    private func EmojiWithSelection(emoji: EmojiArt.Emoji, for size: CGSize) -> some View {
        ZStack {
            if selectedEmojis.contains(matching: emoji) {
                RoundedRectangle(cornerRadius: 2)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    //.font(animatableWithSize: CGFloat(emoji.size) * zoomScale)
                    .frame(width: CGFloat(emoji.size), height: CGFloat(emoji.size))
                    .position(self.position(for: emoji, in: size))
            }
            Text(emoji.text)
                .font(animatableWithSize: emoji.fontSize * zoomScale)
                .position(self.position(for: emoji, in: size))
        }
        .onTapGesture {
            if selectedEmojis.contains(matching: emoji) {
                selectedEmojis.remove(at: selectedEmojis.firstIndex(matching: emoji) ?? 0)
            }
            else {
                selectedEmojis.append(emoji)
            }
        }
        
    }
    
    @State private var steadyStatePanOffset: CGSize = .zero
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, transaction in
                if selectedEmojis.count == 0 {
                    gesturePanOffset = latestDragGestureValue.translation / self.zoomScale
                }
                    
        }
        .onEnded { finalDragGestureValue in
            if selectedEmojis.count == 0 {
                self.steadyStatePanOffset = self.steadyStatePanOffset + (finalDragGestureValue.translation / self.zoomScale)
            }
        }
    }
    
    @State private var steadyStateZoomScale: CGFloat = 1.0
    @GestureState private var gestureZoomScale: CGFloat = 1.0
    
    @State private var emojiStateZoomScale: CGFloat = 1.0
    
    var zoomScale: CGFloat {
        return steadyStateZoomScale * gestureZoomScale
//        if selectedEmojis.count == 0 {
//            return steadyStateZoomScale * gestureZoomScale
//        }
//        else {
//            return steadyStateZoomScale
//        }
    }
    
    @State private var selectedSteadyStateZoomScale: CGFloat = 1.0
    
    var selectedZoomScale: CGFloat {
        return selectedSteadyStateZoomScale * gestureZoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .onEnded { finalGestureScale in
                print("steady: \(steadyStateZoomScale)")
                steadyStateZoomScale *= finalGestureScale
//                if selectedEmojis.count == 0 {
//                    steadyStateZoomScale *= finalGestureScale
//                }
//                else {
//                    for selectedEmoji in selectedEmojis {
//                        document.scaleEmoji(selectedEmoji, by: selectedZoomScale)
//                    }
//                }
            }
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, transaction in
                print("latest: \(latestGestureScale) steady: \(steadyStateZoomScale)")
                gestureZoomScale = latestGestureScale
            }
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                print("double tap")
                withAnimation(){
                    self.zoomToFit(self.document.backgroundImage, in: size)
                }
            }
        
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.height > 0, image.size.width > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            self.steadyStateZoomScale = min(hZoom, vZoom)
            steadyStatePanOffset = .zero
        }
    }
    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x: location.x + size.width / 2, y: location.y + size.height / 2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)
        return location
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            print("dropped \(url)")
            self.document.setBackgroundURL(url)
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                self.document.addEmoji(string, at: location, size: self.defaultEmojiSize)
            }
        }
        return found
    }
    
    private let defaultEmojiSize: CGFloat = 40
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}
