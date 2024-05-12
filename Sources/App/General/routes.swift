import Fluent
import Vapor

func routes(_ app: Application) throws {
    
//    MARK: - Base Requests
    app.get { req async throws in
        try await req.view.render("main-view")
    }
    
//    MARK: - Route Registration
    
}
