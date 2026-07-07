import XCTest
@testable import Barnyardlog

final class StoreTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.entries = []
    }

    func testAddEntryIncreasesCount() {
        let before = store.entries.count
        store.add(LogEntry(group: "Test", status: "Value", notes: "Note"))
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testNewestEntryInsertedFirst() {
        store.add(LogEntry(group: "First", status: "A", notes: ""))
        store.add(LogEntry(group: "Second", status: "B", notes: ""))
        XCTAssertEqual(store.entries.first?.group, "Second")
    }

    func testCanAddMoreWhenUnderLimit() {
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreWhenAtFreeLimit() {
        for i in 0..<Store.freeTierLimit {
            store.add(LogEntry(group: "Item \(i)", status: "V", notes: ""))
        }
        XCTAssertFalse(store.canAddMore)
    }

    func testAddBeyondLimitIsNoOp() {
        for i in 0..<Store.freeTierLimit {
            store.add(LogEntry(group: "Item \(i)", status: "V", notes: ""))
        }
        let countAtLimit = store.entries.count
        store.add(LogEntry(group: "Overflow", status: "V", notes: ""))
        XCTAssertEqual(store.entries.count, countAtLimit)
    }

    func testDeleteAtOffsetsRemovesEntry() {
        store.add(LogEntry(group: "ToDelete", status: "V", notes: ""))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertTrue(store.entries.isEmpty)
    }

    func testUpdateEntryModifiesExisting() {
        store.add(LogEntry(group: "Original", status: "V", notes: ""))
        var entry = store.entries[0]
        entry.group = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries[0].group, "Updated")
    }

    func testFreeTierLimitExceedsSeedCount() {
        XCTAssertGreaterThan(Store.freeTierLimit, 3)
    }
}
