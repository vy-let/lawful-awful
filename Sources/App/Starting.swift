import Vapor
import Fluent



struct Starting {

    func newGame(req: Request) throws -> EventLoopFuture<NewGameResponse> {
        let newReq = try req.content.decode(NewGameRequest.self)
        let game = Game( theme: newReq.theme )

        return game.save( on: req.db )
          .map { NewGameResponse( accessHash: game.accessHash,
                                  playerCode: game.playerCode )}
    }

}



struct NewGameRequest: Content, Validatable {
    let theme: String

    static func validations(_ validations: inout Validations) {
        validations.add("theme", as: String.self, is: !.empty)
    }
}

struct NewGameResponse: Content {
    let accessHash: String
    let playerCode: String
}
