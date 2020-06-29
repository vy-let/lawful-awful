import Fluent
import Vapor

func routes(_ app: Application) throws {

    app.get("status") { _ in "OK" }

    let starting = Starting()
    app.post( "api", "1", "games", use: starting.newGame )

}
