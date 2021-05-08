//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Tarlan Askaruly on 18.04.2021.
//

import Foundation

struct EmojiArt: Codable {
    var backgroundURL: URL?
    var emojis = [Emoji]()
    
    struct Emoji: Identifiable, Codable {
        let id: Int
        
        let text: String
        var x: Int
        var y: Int
        var size: Int
        
        fileprivate init(_ text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data?) {
        if json != nil, let newEmojiArt = try? JSONDecoder().decode(EmojiArt.self, from: json!) {
            self = newEmojiArt // allowed for value type
        }
        else {
            return nil
        }
    }
    
    init() {
        
    }
    
    private var uniqueEmojiId = 0
    
    //mutating func addOffset to Emoji()
    
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        emojis.append(Emoji(text, x: x, y: y, size: size, id: uniqueEmojiId))
        uniqueEmojiId += 1
    }
    
//    mutating func moveEmoji(emoji: Emoji, x: Int, y: Int) {
//        emojis[emojis.firstIndex(matching: emoji)!].x += x
//        emojis[emojis.firstIndex(matching: emoji)!].y += y
//    }
    
//    mutating func selectEmoji(emoji: Emoji) {
//        emojis[emojis.firstIndex(matching: emoji)!].isSelected = !emojis[emojis.firstIndex(matching: emoji)!].isSelected
//    }
//    
//    mutating func unselectAllEmojis() {
//        for index in 0..<emojis.count {
//            emojis[index].isSelected = false
//        }
//    }
    
}
