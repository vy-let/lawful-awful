import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("status") { _ in "OK" }

    let creation = Creation()
    app.post("games", "new", use: creation.newGame)
    app.post("players", "new", use: creation.newPlayer)

    let communication = Communication()

    app.webSocket(
      "games", "connect",
      onUpgrade: { req, ws in
          communication.handleGameNotifs(req, ws)
      })

}
