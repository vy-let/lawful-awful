import Fluent
import Vapor
import RxSwift



struct Communication {



    func handleGameNotifs (_ req: Request, _ ws: WebSocket) {
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



enum EventForClient: String, Codable {
    case gameData
    case gatherPrompts
    case gatherResponses
    case gatherVote
    case results
}

enum GameState: String, Codable {
    case blank
    case gatheringPrompts
    case gatheringResponses
    case gatheringVotes
    case finished
}

protocol MessageForClient {
    var event: EventForClient { get }
}



struct GameDataMessage: MessageForClient, Encodable {
    let event = EventForClient.gameData
    let state: GameState
    let theme: String
    let playerCode: String
}

struct GatherPromptsMessage: MessageForClient, Encodable {
    let event = EventForClient.gatherPrompts
}

struct GatherResponsesMessage: MessageForClient, Encodable {
    let event = EventForClient.gatherResponses
    let prompts: [String]
}

struct GatherVoteMessage: MessageForClient, Encodable {
    let event = EventForClient.gatherVote
    let prompt: String
    let responseLeft: String
    let responseRight: String
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
          .takeWhile { _ in !self.isClosed }
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
