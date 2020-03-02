import Fluent
import Vapor



final class Vote: Model {
    static let schema = "votes"



    @ID(key: "id")
    var id: Int?

    @Parent(key: "for")
    var response: Response

    @Parent(key: "by")
    var player: Player



    init () { }

    init (id: Int? = nil, responseID: Int, playerID: Int) {
        self.id = id
        self.$response.id = responseID
        self.$player.id = playerID
    }
}



struct CreateVote: Migration {
    func prepare ( on database: Database ) -> EventLoopFuture<Void> {
        return database.schema("votes")
          .field( "id", .int, .identifier(auto: true) )
          .field( "for", .int, .references("responses", "id") )
          .field( "by", .int, .references("players", "id") )
          .create()
    }

    func revert ( on database: Database ) -> EventLoopFuture<Void> {
        return database.schema("votes").delete()
    }
}
