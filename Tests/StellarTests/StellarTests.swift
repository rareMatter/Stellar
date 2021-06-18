import XCTest
@testable import Stellar

final class StellarTests: XCTestCase {
    
    /// Creates a composite `SContent` instance and attempts to render it.
    /// If rendering fails a timeout should occur.
    func testCreateCompositeSContent() {
        let composite = TestCompositeContent()
        let _ = composite.renderContent()
    }

    static var allTests = [
        ("testCreateCompositeSContent", testCreateCompositeSContent),
    ]
}

// MARK: - test types

struct TestCompositeContent: SContent {
    
    var body: some SContent {
        SEmptyContent()
    }
}
