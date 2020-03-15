// An active game is distinct from a model game in that it only is
// present in ram. It serves as a dispatch point for all active
// clients.

import Dispatch

class ActiveGame {

    static let coordinatingQ = DispatchQueue(
      label: "space.chillbot.lawful-awful.games-coordinating" )
    static var activeGames = [:] as Dictionary



    let game: Game
    let gameQ: DispatchQueue

    init (_ game: Game) {
        let gameID = game.id?.description ?? "unknown"

        self.gameQ = DispatchQueue(
          label: "space.chillbot.lawful-awful.game-queue-\(gameID)" )
        self.game = game
    }

}
