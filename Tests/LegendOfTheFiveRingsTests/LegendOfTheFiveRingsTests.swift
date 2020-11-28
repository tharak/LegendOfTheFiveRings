import XCTest
import LegendOfTheFiveRings

final class LegendOfTheFiveRingsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LegendOfTheFiveRings().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
        ("testBookContent", testBookContent),
    ]
    
    func testBookContent() {
        let book = Book()
        assert(!book.advatages.isEmpty)
        assert(!book.ancestors.isEmpty)
        assert(!book.armors.isEmpty)
        assert(!book.clans.isEmpty)
        assert(!book.disadvatages.isEmpty)
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
}
