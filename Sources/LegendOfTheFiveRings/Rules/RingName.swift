//
//  File.swift
//  
//
//  Created by Tharak on 12/12/20.
//
import SwiftUI

public enum TraitName: String, CaseIterable {
    case stamina, willpower, strength, perception, reflexes, awareness, agility, intelligence, void

    public var color: Color {
        return RingName.allCases.first(where: {$0.traits.contains(self)})?.color ?? Color.accentColor
    }
}

public enum RingName: String, CaseIterable {
    case fire, water, air, earth, void

    public var traits: [TraitName] {
        switch self {
        case .air:
            return [TraitName.reflexes, TraitName.awareness]
        case .fire:
            return [TraitName.agility, TraitName.intelligence]
        case .water:
            return [TraitName.strength, TraitName.perception]
        case .earth:
            return [TraitName.stamina, TraitName.willpower]
        case .void:
            return [TraitName.void]
        }
    }
    
    public var systemImageName: String {
        switch self {
        case .air:
            return "wind"
        case .fire:
            return "flame"
        case .water:
            return "drop"
        case .earth:
            return "leaf"
        case .void:
            return "camera.aperture"
        }
    }
    
    public var color: Color {
        switch self {
        case .air:
            return Color.purple
        case .fire:
            return Color.red
        case .water:
            return Color.blue
        case .earth:
            return Color.yellow
        case .void:
            return Color.gray
        }
    }
}
