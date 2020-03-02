import Foundation
import Fluent
import Vapor



final class Player: Model {
    static let schema = "players"



    @ID(key: "id")
    var id: Int?

    @Field(key: "name")
    var name: String

    @Parent(key: "game_id")
    var game: Game

    @Field(key: "access_hash")
    var accessHash: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init () { }

    init (name: String, gameID: Int) {
        self.id = nil
        self.name = name
        self.$game.id = gameID
        self.accessHash = String.base64Random(16)
    }

    init (id: Int? = nil, name: String, gameID: Int, accessHash: String, createdAt: Date? = Date()) {
        self.id = id
        self.name = name
        self.accessHash = accessHash
        self.createdAt = createdAt
        self.$game.id = gameID
    }
}



struct CreatePlayer: Migration {
    func prepare ( on database: Database ) -> EventLoopFuture<Void> {
        return database.schema("players")
          .field( "id", .int, .identifier(auto: true) )
          .field( "name", .string, .required )
          .field( "game_id", .int, .references("games", "id") )
          .field( "access_hash", .string, .required )
          .field( "created_at", .datetime, .required )
          .create()
    }

    func revert ( on database: Database ) -> EventLoopFuture<Void> {
        return database.schema("players").delete()
    }
}
