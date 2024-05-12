@testable import App
import XCTVapor
import Fluent


final class AppTests: XCTestCase {
    
//    MARK: - Properties
    var app: Application!
    
    
//    MARK: - Set Up
    override func setUp() async throws {
        self.app = try await Application.make()
        try await configure(app)
        try await app.autoMigrate()
    }
    
//    MARK: - Tear Down
    override func tearDown() async throws {
        try await app.autoRevert()
        try await self.app.asyncShutdown()
        self.app = nil
    }
    
//    MARK: - Test Main View
    func testMainView() async throws {
        try await self.app.test(.GET, .init()) { res async throws in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
