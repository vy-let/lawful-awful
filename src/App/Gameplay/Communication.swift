import Fluent
import Vapor
import RxSwift



struct Communication {



    func handleGameNotifs (_ req: Request, _ ws: WebSocket) {
        // let messages = Observable<GameNotif>.create { subscriber in
        //     let connection = self.authGameConnection(req)
        //     connection.whenSuccess { game in
        //           subscriber.on(.next( GameNotif(kind: game.theme) ))
        //           subscriber.on(.completed)
        //       }
        //     connection.whenFailure { err in subscriber.on(.error( err ))}

        //     return Disposables.create {
        //         print("Will close")
        //         let _ = ws.close()
        //     }
        // }.take(1)

        // let _ = messages.subscribe(onNext: { message in
        //                                try! ws.sendJSON(message)
        //                    },
        //                    onError: { err in
        //                        print(err)
        //                        ws.send("Got an error!")
        //                    })

        let connection = self.authGameConnection(req)
        connection.whenSuccess { game in
            let ag = ActiveGame.forGame(game)
            ag.connect(hostOn: ws)
        }
    }



    func authGameConnection (_ req: Request) -> EventLoopFuture<Game> {
        let hash: String! = req.query["accessHash"]
        guard hash != nil else {
            return req.eventLoop.makeFailedFuture(LoginError.noAccessHash)
        }

        return Game.query(on: req.db)
          .filter( \.$accessHash == hash )
          .first()
          .unwrap( or: LoginError.invalidAccessHash )
    }

}



protocol GameEvent: Codable {
    let type: String
}



struct GameInfoEvent: GameEvent {
    let type = "gameInfo"
    let theme: String
}



enum LoginError: Error {
    case noAccessHash
    case invalidAccessHash
}



extension WebSocket {
    func sendJSON<V> (_ message: V) throws where V: Encodable {
        let encoded = try JSONEncoder().encode(message)
        self.send(raw: encoded, opcode: .text, fin: true)
    }



    func subscribe<V> (to messages: Observable<V>) -> Disposable
      where V: Encodable {
        return messages
          .takeWhile { !self.isClosed }
          .subscribe(
            onNext: { message in
                do {
                    try self.sendJSON(message)
                } catch {
                    print(error)
                    let _ = self.close()
                }
            },
            onError: { err in
                print(err)
                let _ = self.close()
            },
            onCompleted: {
                print("Closing socket on successful complete")
                let _ = self.close()
            }
          )
    }
}
