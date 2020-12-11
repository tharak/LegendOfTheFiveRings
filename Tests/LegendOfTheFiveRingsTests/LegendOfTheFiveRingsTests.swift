import XCTest
import LegendOfTheFiveRings
import CoreData

final class LegendOfTheFiveRingsTests: XCTestCase {

    let book = Book()

    func testBookContent() {
        assert(!book.advatages.isEmpty)
        assert(!book.disadvatages.isEmpty)
        assert(!book.armors.isEmpty)
        assert(!book.clans.isEmpty)
        assert(!book.ancestors.isEmpty)
        assert(!book.families.isEmpty)
        assert(!book.katas.isEmpty)
        assert(!book.kihos.isEmpty)
        assert(!book.schools.isEmpty)
        assert(!book.shadowlandsPowers.isEmpty)
        assert(!book.skills.isEmpty)
        assert(!book.spells.isEmpty)
        assert(!book.tattoos.isEmpty)
        assert(!book.weapons.isEmpty)
    }

    func testAdvatages() {
        let advantage = book.advatages.first!
        XCTAssertNotNil(advantage)
        assert(advantage.name == "Absolute Direction")
        assert(advantage.subtype == Subtype(rawValue: "Mental"))
        assert(advantage.points == "1")
        assert(advantage.description == "You possess an almost supernatural sense of direction, and you always know what direction is north, no matter the circumstances.\n This ability does not function if you are more than one day’s travel inside the Shadowlands.")
    }

    func testDisadvatages() {
        let disadvantage = book.disadvatages.first!
        XCTAssertNotNil(disadvantage)
        assert(disadvantage.name == "Antisocial")
        assert(disadvantage.subtype == Subtype(rawValue: "Social"))
        assert(disadvantage.points == "2,4")
        assert(disadvantage.description == "You find the presence of others uncomfortable, so much so that it is immediately obvious to those around you. Your preference for solitude causes you to behave in a manner that might best be described as rude. If you take the 2 point version of this Disadvantage, you suffer a penalty of -1k0 to all Social Skill Rolls. For 4 points, the penalty is -1k1. This Disadvantage is worth 1 additional point to Crab characters.")
    }

    func testArmors() {
        let armor = book.armors.first!
        XCTAssertNotNil(armor)
        assert(armor.name == "Ashigaru Armor")
        assert(armor.tn == "+3")
        assert(armor.reduction == "1")
        assert(armor.price == "5 Koku")
        assert(armor.description == "Much less expensive to produce than either light or heavy samurai armor, ashigaru armor is also lighter, less restrictive, and less protective than traditional light and heavy armor. It consists of plates that protect the head, torso, and upper legs.\n It is not unheard of for scouts among the samurai caste to wear ashigaru armor in lieu of traditional samurai armor to afford them greater mobility in the execution of their duties.\n Ronin also wear it because of its affordability.")
    }

    func testClan() {
        let clan = book.clans.first!
        XCTAssertNotNil(clan)
        assert(clan.name == "Crab")
        assert(clan.great == true)
        assert(clan.description == "In any gathering of samurai, it is all too easy to pick out a Crab from the members of the other clans. Crab Clan samurai are larger and more powerful than those of virtually any other family or clan in the Empire, and unfortunately, are often ruder, less diplomatic, and less refined than others as well. This is not necessarily a deliberate act on the part of the Crab; they simply have radically different priorities than the rest of the Empire. Since the founding of Rokugan, the Crab have stood guard in the south, protecting the Empire from the demons and monstrosities that dwell within the blighted region known as the Shadowlands. While other clans have enjoyed peace and serenity for centuries at a time, the Crab know only war, day in and day out, year upon year. While they certainly do not begrudge their duties, they do tend to resent those more sophisticated and effete samurai who mock the Crab while benefiting from the protection they afford.\n Duty is by far the tenet of Bushido the Crab value the most, rivaled only by Courage. Perhaps because of the duties they fulfill, the Crab care very little for social niceties, preferring blunt honesty and practicality to polite conversation.\n They believe that strength grants the right to rule, and they resent the fact that clans they perceive as weaker, especially the Crane and Scorpion, tend to enjoy more wealth and comforts than they do. The Crab embrace their duty to the Empire, however, because their lord and founder Hida was defeated by Hantei at the dawn of the Empire, proving Hantei to be stronger. For this reason alone, the Crab serve the Emperor faithfully. In times of weak rule, however, some among them have been sorely tempted to wonder why a Crab upon the throne might not be a more reasonable solution for the Empire as a whole.\n The Crab were founded by Hida, the largest and most physically powerful of the children of the Sun and Moon.\n Although not a dullard by any means, Hida was nevertheless generally unconcerned with studying things such as religion or philosophy. He gathered together only the most powerful and fearsome warriors to bear his name, and the Hida family has been acknowledged, grudgingly in some cases, as among the greatest warriors of the Empire for centuries. The Hida have ruled the Crab Clan well for a thousand years, not only by excelling at the war which is the clan’s birthright, but also by understanding the importance of delegating duties to gifted subordinates, which the Hida are fortunate to have in abundance.\n The ranks of the Crab are not limited to the Hida family.\n The Hiruma, the oldest servants of the Hida, are gifted scouts and yojimbo, emphasizing speed and athleticism over the Hida’s strength. The Kaiu are brilliant engineers and tacticians, and advise their lords on all matters related to warfare.\n The much-maligned Kuni have sacrificed much to understand the enemies the Crab face, and these shugenja are frequently accused of terrible acts by other families within the Empire. The wily Yasuki, who joined the clan after the First Yasuki War, are vastly different from the rest of the Crab, and are both exceptional merchants and extremely manipulative politicians, serving the clan in the courts. The Toritaka family, part of the Crab for less than a century, are well-versed in the spirits and undead that can slip past the Great Carpenter Wall, and assist in hunting down those who have escaped the Crab’s notice.\n The Crab lands are largely mountainous, with some small degree of open land in the northern foothills and scattered among the peaks of their various mountain ranges, notably the Twilight Mountains and the Wall Above the Ocean Mountains. A portion of their lands, primarily those of the Kuni and Hiruma, have suffered terribly from previous assaults by the Shadowlands, and are almost completely barren.\n As a result, the Crab are forced to import a great deal of their food. Fortunately, the mountains are rich in ore, giving them ample supplies for trade.")
    }

    func testAncestors() {
        let ancestor = book.ancestors.first!
        XCTAssertNotNil(ancestor)
        assert(ancestor.name == "Hida")
        assert(ancestor.description == "Hida was a warrior of unmatched strength and endurance, who relied on that to defeat all foes, never backing down from any of them, even his own Taint-corrupted son. With Hida watching over you, your blows strike hard and true – you gain +1k0 to all damage rolls and may ignore 4 points of an enemy’s Reduction, regardless of what weapon you are using.\n Further, any Crab who fight alongside you in a skirmish are inspired by the spirit of Hida which infuses your frame, and gain +1 bonus Void point (if they do not use this Void point by the end of the skirmish, it is lost).")
        assert(ancestor.points == "14")
        assert(ancestor.clan == "Crab")
        assert(ancestor.demands == "Any Round that at least one fellow Crab is wounded within your sight, you must suffer 1 Wound in sympathy.\n (This does not increase if multiple Crab are wounded in the same Round.) This Wound ignores Reduction and any other effects which would otherwise negate damage. However, you can voluntarily choose not to suffer the Wound. If you ever refuse to suffer these Wounds, or if you ever voluntarily retreat from a fight with a creature of the Shadowlands, Hida will abandon you.")
    }

    func testFamilies() {
        let family = book.families.first!
        
        assert(family.name == "Hida")
        assert(family.clan == "Crab")
        assert(family.benefit == "+1 Strength")
        assert(family.description == "The descendants of the Kami Hida are among the largest and most powerful samurai in all the Empire. The burden of defending the Empire falls upon them, and they are both incredible warriors and skilled defensive tacticians. Hida samurai often resent the other Clans for enjoying their protection even as they mock the Crab for their mannerisms.")
        
        assert(family.textToTrait(text: family.benefit) == TraitName.strength)
    }

    func testFamilyBenefit() {
        let family = book.families.first!
        XCTAssert(family.textToTrait(text: "+1 Strength") == TraitName.strength)

        for family in book.families {
            if family.name.contains("True Ronin") {
                XCTAssertNil(family.bonusTrait(), "\(family.benefit)")
            } else {
                XCTAssertNotNil(family.bonusTrait(), "\(family.benefit)")
            }
        }
    }

    func testSchoolBenefit() {
        let school = book.schools.first!
        assert(school.benefit == "+1 Stamina")
        assert(school.bonusTrait() == TraitName.stamina)
        
        for school in book.schools {
            if school.advanced || ["Tsuno Ravager", "Tsuno Soultwister", "The Fuzake Shugenja"].contains(school.name){
                XCTAssertNil(school.bonusTrait(), school.benefit ?? "\(school.name) has no benefit")
            } else {
                XCTAssertNotNil(school.bonusTrait(), school.benefit ?? "\(school.name) has no benefit")
            }
        }
    }
}
