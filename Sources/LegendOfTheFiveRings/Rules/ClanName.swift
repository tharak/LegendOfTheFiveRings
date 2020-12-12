//
//  File.swift
//  
//
//  Created by Tharak on 12/12/20.
//

public enum ClanName: String, CaseIterable {
    case crab, crane, dragon, lion, mantis, phoenix, scorpion, spider, unicorn, badger, bat, boar, dragonfly, falcon, fox, hare, monkey, oriole, ox, snake, sparrow, tiger, tortoise, imperial, ronin
    
    public static func emoji(name: String?) -> String {
        guard let unwrapName = name, let clanName = ClanName(rawValue: unwrapName) else {
            return name ?? ""
        }
        switch clanName {
        case .crab:
            return "🦀"
        case .crane:
            return "🦩"
        case .dragon:
            return "🐲"
        case .lion:
            return "🦁"
        case .mantis:
            return "🦗"
        case .phoenix:
            return "🐓"
        case .scorpion:
            return "🦂"
        case .spider:
            return "🕷"
        case .unicorn:
            return "🦄"
        case .badger:
            return "🦡"
        case .bat:
            return "🦇"
        case .boar:
            return "🐗"
        case .dragonfly:
            return "🪰"
        case .falcon:
            return "🦅"
        case .fox:
            return "🦊"
        case .hare:
            return "🐇"
        case .monkey:
            return "🐒"
        case .oriole:
            return "🦜"
        case .ox:
            return "🐂"
        case .snake:
            return "🐍"
        case .sparrow:
            return "🐥"
        case .tiger:
            return "🐅"
        case .tortoise:
            return "🐢"
        case .imperial:
            return "⚜️"
        case .ronin:
            return "🌊"
        }
    }
}
