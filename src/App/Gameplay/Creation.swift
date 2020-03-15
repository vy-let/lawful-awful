import Fluent
import Vapor



struct Creation {

    func newGame (req: Request) throws -> EventLoopFuture<NewGameResponse> {
        let newReq = try req.content.decode(NewGameRequest.self)
        let game = Game( theme: newReq.theme )

        return game.save( on: req.db )
          .map { NewGameResponse( accessHash: game.accessHash,
                                  playerCode: game.playerCode )}
    }



    func newPlayer (req: Request) throws -> EventLoopFuture<NewPlayerResponse> {
        let newReq = try req.content.decode(NewPlayerRequest.self)

        return Game.query(on: req.db)
        // Find the game by its code:
          .filter( \.$playerCode == newReq.gameCode )
          .first()
          .unwrap( or: Abort( .notFound, reason: "Could not find game \(newReq.gameCode)" ))

        // Make a player and wait for it to save:
          .map { game in Player( name: newReq.name, gameID: game.id! ) }
          .flatMap { player in player.save(on: req.db).map { player }}

        // Form the network response:
          .map { player in NewPlayerResponse( accessHash: player.accessHash )}
    }

}



struct NewGameRequest: Content, Validatable {
    let theme: String

    static func validations (_ validations: inout Validations) {
        validations.add("theme", as: String.self, is: !.empty)
    }
}

struct NewGameResponse: Content {
    let accessHash: String
    let playerCode: String
}



struct NewPlayerRequest: Content, Validatable {
    let name: String
    let gameCode: String

    static func validations (_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
    }
}

struct NewPlayerResponse: Content {
    let accessHash: String
}
