//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Tarlan Askaruly on 18.04.2021.
//

import Foundation
import SwiftUI

class EmojiArtDocument: ObservableObject {
    static let pallete: String = "🍋👻🎃🏈⚽️🏓"
    
    @Published private var emojiArt: EmojiArt {
        didSet {
            print("json: \(emojiArt.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
        }
    }
    
    @Published private(set) var backgroundImage: UIImage?
    
    private static let untitled = "EmojiArtDocument.untitled"
    
    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
        //emojiArt.unselectAllEmojis()
        fetchBackgroundImageData()
    }
    
    var emojis: [EmojiArt.Emoji] {
        emojiArt.emojis
    }
    
    //MARK: -Intent(s)
    
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
//    func selectEmoji(emoji: EmojiArt.Emoji) {
//        emojiArt.selectEmoji(emoji: emoji)
//    }
//    
//    func unselectAllEmojis() {
//        emojiArt.unselectAllEmojis()
//    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    func setBackgroundURL(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
        fetchBackgroundImageData()
    }
    
    func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = emojiArt.backgroundURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if url == self.emojiArt.backgroundURL! {
                            self.backgroundImage = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat {
        CGFloat(self.size)
    }
    var location: CGPoint {
        CGPoint(x: CGFloat(self.x), y: CGFloat(self.y))
    }
}
