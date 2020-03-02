import Fluent
import Vapor



final class Prompt: Model {
    static let schema = "prompts"



    @ID(key: "id")
    var id: Int?

    @Field(key: "prompt")
    var prompt: String

    @Parent(key: "for")
    var game: Game

    @Parent(key: "by")
    var player: Player

    init () { }

    init (id: Int? = nil, prompt: String, gameID: Int, playerID: Int) {
        self.id = id
        self.prompt = prompt
        self.$game.id = gameID
        self.$player.id = playerID
    }
}



struct CreatePrompt: Migration {
    func prepare ( on database: Database ) -> EventLoopFuture<Void> {
        return database.schema("prompts")
          .field( "id", .int, .identifier(auto: true) )
          .field( "prompt", .string, .required )
          .field( "for", .int, .references("games", "id") )
          .field( "by", .int, .references("players", "id") )
          .create()
    }

    func revert ( on database: Database ) -> EventLoopFuture<Void> {
        return database.schema("prompts").delete()
    }
}
