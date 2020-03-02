import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("status") { _ in "OK" }

    let gameplay = Gameplay()
    app.post("games", "new", use: gameplay.newGame)
    app.post("players", "new", use: gameplay.newPlayer)

}
