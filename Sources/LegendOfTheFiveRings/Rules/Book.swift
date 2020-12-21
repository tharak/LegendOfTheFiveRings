import Foundation

public class Book: ObservableObject {

    public init() {}

    public let clans: [Clan] = load(resource: "Clans") ?? []
    public let families: [Family] = load(resource: "Families") ?? []
    public let schools: [School] = load(resource: "Schools") ?? []
    public let skills: [Skill] = load(resource: "Skills") ?? []
    public let weapons: [Weapon] = load(resource: "Weapons") ?? []
    public let armors: [Armor] = load(resource: "Armors") ?? []
    public let advatages: [Advantage] = load(resource: "Advantages") ?? []
    public let disadvatages: [Disadvantage] = load(resource: "Disadvantages") ?? []
    public let spells: [Spell] = load(resource: "Spells") ?? []
    public let katas: [Kata] = load(resource: "Katas") ?? []
    public let kihos: [Kiho] = load(resource: "Kihos") ?? []
    public let tattoos: [Tattoo] = load(resource: "Tattoos") ?? []
    public let ancestors: [Ancestor] = load(resource: "Ancestors") ?? []
    public let shadowlandsPowers: [ShadowPower] = load(resource: "ShadowlandsPowers") ?? []

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
    
    func skillsForExtra(text: String) -> [Skill] {
        return skills.filter { (skill) -> Bool in
            if ["skills", "skill"].contains(text.lowercased()) {
                return true
            }
            if text.contains("Weapon") {
                return skill.type.contains(text)
            }
            if ["non-Low Skill", "non-Low Skills"].contains(text) {
                return skill.category != Category.low && !skill.type.contains("Weapon Skill, considered a Low Skill")
            }
            if ["non-Bugei Skill", "High Skill or Merchant or Low Skill"].contains(text) {
                return skill.category != Category.bugei
            }
            if text == "non-High Skills" {
                return skill.category != Category.high
            }
            return text.contains(skill.category.rawValue) || text.contains(skill.name)
        }
    }
}
