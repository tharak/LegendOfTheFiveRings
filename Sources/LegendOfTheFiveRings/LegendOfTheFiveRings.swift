struct LegendOfTheFiveRings {
    var text = "Hello, World!"
}

import Foundation

struct Book {
    let clans: [Clan] = load(resource: "Clans") ?? []
    let families: [Family] = load(resource: "Families") ?? []
    let schools: [School] = load(resource: "Schools") ?? []
    let skills: [Skill] = load(resource: "Skills") ?? []
    let weapons: [Weapon] = load(resource: "Weapons") ?? []
    let armors: [Armor] = load(resource: "Armors") ?? []
    let advatages: [Advantage] = load(resource: "Advantages") ?? []
    let disadvatages: [Disadvantage] = load(resource: "Disadvantages") ?? []
    let spells: [Spell] = load(resource: "Spells") ?? []
    let katas: [Kata] = load(resource: "Katas") ?? []
    let kihos: [Kiho] = load(resource: "Kihos") ?? []
    let tattoos: [Tattoo] = load(resource: "Tattoos") ?? []
    let ancestors: [Ancestor] = load(resource: "Ancestors") ?? []
    let shadowlandsPowers: [ShadowPower] = load(resource: "ShadowlandsPowers") ?? []
    
    static func load<T: Codable>(resource: String, withExtension: String = "json") -> T? {
        if let path = Bundle.module.url(forResource: resource, withExtension: withExtension) {
            do {
                let data = try Data(contentsOf: path, options: .mappedIfSafe)
                if let items = try? JSONDecoder().decode(T.self, from: data) {
                    return items
                } else {
                    print("parse failed \(resource).\(withExtension)")
                    return nil
                }
            } catch {
                print("load failed \(resource).\(withExtension)")
                return nil
            }
        } else {
            return nil
        }
    }
}
