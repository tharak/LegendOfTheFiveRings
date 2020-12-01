//
//  File.swift
//  
//
//  Created by Tharak on 28/11/20.
//

import Foundation

public enum TraitName: String, CaseIterable {
    case stamina, willpower, strength, perception, reflexes, awareness, agility, intelligence, void
}

public enum ClanName: String, CaseIterable {
    case crab, crane, dragon, lion, mantis, phoenix, scorpion, spider, unicorn, badger, bat, boar, dragonfly, falcon, fox, hare, monkey, oriole, ox, snake, sparrow, tiger, tortoise, imperial, ronin
}

public enum RingName: String, CaseIterable {
     case fire, water, air, earth, void
}

public enum WoundLevel: String, CaseIterable {
    case healthy, nicked, grazed, hurt, injured, crippled, down, out
}

// MARK: - Clan
public struct Clan: Codable, Hashable {
    public let name, description: String
    public let great: Bool
}

// MARK: - Family
public struct Family: Codable, Hashable {
    public let name, clan, benefit, description: String

    public func bonusTrait() -> TraitName? {
        return name.contains("True Ronin") ? nil : textToTrait(text: benefit)
    }
    
    public func textToTrait(text: String) -> TraitName {
        TraitName.allCases.first(where: {text.lowercased().contains($0.rawValue)})!
    }
}

// MARK: - School
public struct School: Codable, Hashable {
    public let name: String
    public let clan: String
    public let description: String
    public let discipline: Discipline
    public let benefit, honor, skills, outfit: String?
    public let advanced: Bool
    public let technique1, technique1Description, technique2, technique2Description: String?
    public let technique3, technique3Description, technique4, technique4Description: String?
    public let technique5, technique5Description, affinity, spells: String?
    public let ringTraits, other: String?

    public func bonusTrait() -> TraitName? {
        if let benefit = benefit {
            return TraitName.allCases.first(where: {benefit.lowercased().contains($0.rawValue)})!
        }
        return nil
    }
}

public enum Discipline: String, Codable, Hashable {
    case artisan = "Artisan"
    case artisanBushi = "Artisan, Bushi"
    case bushi = "Bushi"
    case courtier = "Courtier"
    case monk = "Monk"
    case ninja = "Ninja"
    case shugenja = "Shugenja"
}

// MARK: - Skill
public struct Skill: Codable, Hashable {

    public let name: String
    public let category: Category
    public let description, emphasis, mastery, trait: String
    public let type: String
}

public enum Category: String, Codable, Hashable {
    case bugei = "Bugei"
    case high = "High"
    case low = "Low"
    case merchant = "Merchant"
}

// MARK: - Weapon
public struct Weapon: Codable, Hashable {
    public let name, type: String
    public let dr, special, price, description: String?
    public let range, keywords, strength: String?
}

// MARK: - Armor
public struct Armor: Codable, Hashable {
    public let name, tn, reduction, price: String
    public let description: String
    public let special: String?
}

// MARK: - Advantage
public struct Advantage: Codable, Hashable {
    public let name: String
    public let subtype: Subtype
    public let points, description: String
}

public enum Subtype: String, Codable, Hashable {
    case material = "Material"
    case mental = "Mental"
    case mystical = "Mystical"
    case physical = "Physical"
    case physicalSpiritual = "Physical, Spiritual"
    case social = "Social"
    case spiritual = "Spiritual"
    case varies = "Varies"
}

// MARK: - Disadvantage
public struct Disadvantage: Codable, Hashable {
    public let name: String
    public let subtype: Subtype
    public let points, description: String
}

// MARK: - Spell
public struct Spell: Codable, Hashable {
    public let name: String
    public let ring: Ring
    public let mastery, keywords: String?
    public let range, area, duration: String
    public let raises: String?
    public let description: String
}

public enum Ring: String, Codable, Equatable {
    case air = "Air"
    case all = "All"
    case any = "Any"
    case anyNonVoid = "Any non-Void"
    case earth = "Earth"
    case fire = "Fire"
    case name = "Name"
    case void = "Void"
    case water = "Water"
}

// MARK: - Ancestor
public struct Ancestor: Codable, Hashable {
    public let name, description, points, clan, demands: String
}

// MARK: - Kata
public struct Kata: Codable, Hashable {
    public let name: String
    public let ring: Ring
    public let mastery, schools, description: String
}

// MARK: - Kiho
public struct Kiho: Codable, Hashable {
    public let name: String
    public let ring: Ring
    public let mastery, atemi: String
    public let type: KihoType
    public let description: String
}

public enum KihoType: String, Codable, Hashable {
    case kharmic = "Kharmic"
    case martial = "Martial"
    case mystical = "Mystical"
    case typeInternal = "Internal"
}

// MARK: - Tattoo
public struct Tattoo: Codable, Hashable {
    public let name, description: String
}

// MARK: - ShadowPower
public struct ShadowPower: Codable, Hashable {
    public let name, description: String
    public let level: Level
}

public enum Level: String, Codable, Hashable {
    case akutenshi = "Akutenshi"
    case greater = "Greater"
    case lesser = "Lesser"
    case minor = "Minor"
}
