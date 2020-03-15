import Fluent
import Vapor
import RxSwift



struct Communication {
    static let communicatorQ = DispatchQueue(
      label: "space.chillbot.lawful-awful.websockets",
      autoreleaseFrequency: .workItem )

    static var gameListeners: Dictionary<Int, Array<WebSocket>> = [:]



    // func handleGameNotifs (_ req: Request, _ ws: WebSocket) {
    //     let messages: PassthroughSubject<GameNotif, LoginError> = PassthroughSubject()

    //     self.authGameConnection(req)
    //       .whenSuccess { game in messages.send(GameNotif(kind: game.theme)) }
    //       .whenFailure { err in messages.send(completion: .failure(err)) }

    //     messages.sink(
    //       receiveCompletion: { completion in
    //           ws.close()
    //       },
    //       receiveValue: { message in
    //           ws.send(text: JSONEncoder().encode(message)!)
    //       }
    //     )
    // }

    func handleGameNotifs (_ req: Request, _ ws: WebSocket) {
        let messages = Observable<GameNotif>.create { subscriber in
            let connection = self.authGameConnection(req)
            connection.whenSuccess { game in
                  subscriber.on(.next( GameNotif(kind: game.theme) ))
                  subscriber.on(.completed)
              }
            connection.whenFailure { err in subscriber.on(.error( err ))}

            return Disposables.create {
                print("Will close")
                let _ = ws.close()
            }
        }.take(1)

        let _ = messages.subscribe(onNext: { message in
                                       try! ws.sendJSON(message)
                           },
                           onError: { err in
                               print(err)
                               ws.send("Got an error!")
                           })
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



struct GameNotif: Content {
    let kind: String
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
}
