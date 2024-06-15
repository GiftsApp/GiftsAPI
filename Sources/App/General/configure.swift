import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

public func configure(_ app: Application) async throws {
    
//    MARK: - File Middleware
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.resourcesDirectory))
    
//    MARK: - Settings
    app.routes.defaultMaxBodySize = "10mb"
    app.http.server.configuration.responseCompression = .enabled
    app.http.server.configuration.requestDecompression = .enabled(limit: .none)

//    MARK: - Data Base
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)
    
//    MARK: - Leaf
    app.views.use(.leaf)

//    MARK: - Register Migrations
    app.migrations.add(CreateFile())
    app.migrations.add(CreateLottery())
    app.migrations.add(CreateQuest())
    app.migrations.add(CreateButton())
    app.migrations.add(CreateAdmin())
    app.migrations.add(CreateAdminToken())
    app.migrations.add(CreateUser())
    app.migrations.add(CreateUserToken())
    
    #if DEBUG
    try await app.autoRevert()
    #endif
    try await app.autoMigrate()
    
//    MARK: - Managers
    AutoClickerManager.shared.start(app)
    
    
//    MARK: - Register Routes
    try routes(app)
}
