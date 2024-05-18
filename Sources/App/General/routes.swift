import Fluent
import Vapor

func routes(_ app: Application) throws {
    
//    MARK: - Base Requests
    app.get { req async throws in
        try await req.view.render("main-view")
    }
    
//    MARK: - Route Registration
    try app.register(collection: AdminController())
    try app.register(collection: AdminTokenController())
    try app.register(collection: ButtonController())
    try app.register(collection: FileController())
    try app.register(collection: LotteryController())
    try app.register(collection: QuestController())
    try app.register(collection: UserController())
    
}
