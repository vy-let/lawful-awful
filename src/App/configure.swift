import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreateGame())
    app.migrations.add(CreatePlayer())
    app.migrations.add(CreatePrompt())
    app.migrations.add(CreateResponse())
    app.migrations.add(CreateVote())

    // register routes
    try routes(app)
}
