import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor
import Gatekeeper
import Redis

public func configure(_ app: Application) async throws {
    
//    MARK: - File Middleware
    var middlewares = Middlewares()
    
    middlewares.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    middlewares.use(FileMiddleware(publicDirectory: app.directory.resourcesDirectory))
    
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
    
//    MARK: - Redis
    app.redis.configuration = try RedisConfiguration(
        serverAddresses: [
            .makeAddressResolvingHost("localhost", port: 8080),
        ]
    )
    
//    MARK: - Rate Limit
    app.caches.use(.memory)
    app.gatekeeper.config = .init(maxRequests: 10, per: .second)
    middlewares.use(GatekeeperMiddleware())
    app.gatekeeper.keyMakers.use(.userID)
    
//    MARK: - Cors
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .originBased,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH, .CONNECT],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin],
        allowCredentials: true
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    
    middlewares.use(cors, at: .beginning)
    middlewares.use(ErrorMiddleware.default(environment: app.environment))
    app.middleware = middlewares
    
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
