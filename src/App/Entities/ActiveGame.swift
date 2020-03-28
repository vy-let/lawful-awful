// An active game is distinct from a model game in that it only is
// present in ram. It serves as a dispatch point for all active
// clients.

import Dispatch
import RxSwift

class ActiveGame {

    // TODO: Remove stale games or ones that have finished

    static let coordinatingQ = DispatchQueue(
      label: "space.chillbot.lawful-awful.games-coordinating" )
    static var activeGames: Dictionary<Int, ActiveGame> = [:]

    static func forGame (_ game: Game) -> ActiveGame {
        // We only have ActiveGames based on games that are already in
        // the database, and thus already have ids.
        let gameID = game.id!

        return coordinatingQ.sync {
            if let existing = activeGames[gameID] {
                return existing
            } else {
                let rehydrated = ActiveGame(game)
                activeGames[gameID] = rehydrated
                return rehydrated
            }
        }
    }



    let game: Game
    let events: PublishSubject<GameEvent>
    let scheduler: SerialDispatchQueueScheduler
    let disposeBag: DisposeBag

    init (_ game: Game) {
        let gameID = game.id?.description ?? "unknown"

        self.game = game
        self.events = PublishSubject()
        self.scheduler = SerialDispatchQueueScheduler(
          qos: .userInteractive
          internalSerialQueueName: "space.chillbot.lawful-awful.game-queue-\(gameID)" )
        self.disposeBag = DisposeBag()
    }



    func connect (hostOn socket: WebSocket) {

    }

    func connect (player: Player, on socket: WebSocket) {

    }



    enum GameError: Error {
        case noID
    }

}
