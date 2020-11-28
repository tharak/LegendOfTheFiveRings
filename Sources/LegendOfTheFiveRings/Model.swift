//
//  File.swift
//  
//
//  Created by Tharak on 28/11/20.
//

import Foundation

// MARK: - Clan
struct Clan: Codable {
    let name, description: String
    let great: Bool
}

// MARK: - Family
struct Family: Codable {
    let name, clan, benefit, description: String
}

// MARK: - School
struct School: Codable {
    let name: String
    let clan: String
    let description: String
    let discipline: Discipline
    let benefit, honor, skills, outfit: String?
    let advanced: Bool
    let technique1, technique1Description, technique2, technique2Description: String?
    let technique3, technique3Description, technique4, technique4Description: String?
    let technique5, technique5Description, affinity, spells: String?
    let ringTraits, other: String?
}

enum Discipline: String, Codable {
    case artisan = "Artisan"
    case artisanBushi = "Artisan, Bushi"
    case bushi = "Bushi"
    case courtier = "Courtier"
    case monk = "Monk"
    case ninja = "Ninja"
    case shugenja = "Shugenja"
}

// MARK: - Skill
struct Skill: Codable {

    let name: String
    let category: Category
    let description, emphasis, mastery, trait: String
    let type: String

    var rank: Int?
    var emphases: [String]?
    var isSchool: Bool?

    mutating func updateRank(newRank: Int) {
        self.rank = newRank
    }
}

enum Category: String, Codable {
    case bugei = "Bugei"
    case high = "High"
    case low = "Low"
    case merchant = "Merchant"
}

// MARK: - Weapon
struct Weapon: Codable {
    let name, type: String
    let dr, special, price, description: String?
    let range, keywords, strength: String?
}

// MARK: - Armor
struct Armor: Codable {
    let name, tn, reduction, price: String
    let description: String
    let special: String?
}

// MARK: - Advantage
struct Advantage: Codable {
    let name: String
    let subtype: Subtype
    let points, description: String

    var cost: Int?
}

enum Subtype: String, Codable {
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
struct Disadvantage: Codable {
    let name: String
    let subtype: Subtype
    let points, description: String

    var cost: Int?
}

// MARK: - Spell
struct Spell: Codable {
    let name: String
    let ring: Ring
    let mastery, keywords: String?
    let range, area, duration: String
    let raises: String?
    let description: String
}

enum Ring: String, Codable, Equatable {
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
struct Ancestor: Codable {
    let name, description, points, clan, demands: String
}

// MARK: - Kata
struct Kata: Codable {
    let name: String
    let ring: Ring
    let mastery, schools, description: String
}

// MARK: - Kiho
struct Kiho: Codable {
    let name: String
    let ring: Ring
    let mastery, atemi: String
    let type: KihoType
    let description: String
}

enum KihoType: String, Codable {
    case kharmic = "Kharmic"
    case martial = "Martial"
    case mystical = "Mystical"
    case typeInternal = "Internal"
}

// MARK: - Tattoo
struct Tattoo: Codable {
    let name, description: String
}

// MARK: - ShadowPower
struct ShadowPower: Codable {
    let name, description: String
    let level: Level
}

enum Level: String, Codable {
    case akutenshi = "Akutenshi"
    case greater = "Greater"
    case lesser = "Lesser"
    case minor = "Minor"
}
