import Fluent
import FluentSQLiteDriver
import Vapor

func loadMigrations(_ app: Application) {
    let ms = app.migrations
    ms.add( CreateGame() )
}
