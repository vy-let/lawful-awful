// An active game is distinct from a model game in that it only is
// present in ram. It serves as a dispatch point for all active
// clients.

import Dispatch
// import RxSwift
import Vapor

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
    var hostConnections: Set<WebSocket> = []
    var playerConnections: Dictionary<Int, WebSocket> = [:]
    let gameQ: DispatchQueue

    // let events: PublishSubject<GameEvent>
    // let scheduler: SerialDispatchQueueScheduler
    // let disposeBag: DisposeBag

    init (_ game: Game) {
        let gameID = game.id?.description ?? "unknown"

        self.game = game
        self.gameQ = DispatchQueue(
          label: "space.chillbot.lawful-awful.game-queue-\(gameID)" )

        // self.events = PublishSubject()
        // self.scheduler = SerialDispatchQueueScheduler(
        //   qos: .userInteractive,
        //   internalSerialQueueName: "space.chillbot.lawful-awful.game-queue-\(gameID)" )
        // self.disposeBag = DisposeBag()
    }



    func connect (hostOn socket: WebSocket) {
        gameQ.async(execute: DispatchWorkItem {
                        self.hostConnections.insert(socket)
                    })
        socket.onCloseCode { code in
            self.gameQ.async(execute: DispatchWorkItem {
                            self.hostConnections.remove(socket)
                        })
        }
    }

    func connect (player: Player, on socket: WebSocket) {
        gameQ.async(execute: DispatchWorkItem {
                        self.playerConnections.append(socket)
                    })
    }



    enum GameError: Error {
        case noID
    }

}
