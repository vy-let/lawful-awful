import Foundation
import Vapor
import Fluent



final class Game: Model {
    static let schema = "games"

    // Omit I and O because in some fonts they can be ambiguous
    static let playerCodeLetters = "ABCDEFGHJKLMNPQRSTUVWXYZ"



    @ID(custom: .id)
    var id: Int?

    @Field(key: "theme")
    var theme: String

    @Field(key: "access_hash")
    var accessHash: String

    @Field(key: "player_code")
    var playerCode: String

    @Field(key: "start_time")
    var startTime: Date

    init () { }

    init (theme: String) {
        self.id = nil
        self.theme = theme

        // 18 bytes is convenient because (as a multiple of 3) it
        // needs no padding characters:
        self.accessHash = String.base64Random(18)
        self.playerCode = String.randomChars(4, from: Game.playerCodeLetters)
        self.startTime = Date()
    }

    init (id: Int? = nil, theme: String, accessHash: String, playerCode: String, startTime: Date) {
        self.id = id
        self.theme = theme
        self.accessHash = accessHash
        self.playerCode = playerCode
        self.startTime = startTime
    }
}



struct CreateGame: Migration {
    func prepare ( on database: Database ) -> EventLoopFuture<Void> {
        return database.schema("games")
          .field( "id", .int, .identifier(auto: true) )
          .field( "theme", .string, .required )
          .field( "access_hash", .string, .required )
          .field( "player_code", .string, .required)
          .field( "start_time", .datetime, .required )
          .unique( on: "player_code" )
          .create()
    }

    func revert ( on database: Database ) -> EventLoopFuture<Void> {
        return database.schema("games").delete()
    }
}
