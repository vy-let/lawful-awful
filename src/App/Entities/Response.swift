import Fluent
import Vapor



final class Response: Model {
    static let schema = "responses"



    @ID(key: "id")
    var id: Int?

    @Field(key: "response")
    var response: String

    @Parent(key: "to")
    var prompt: Prompt

    @Parent(key: "by")
    var player: Player



    init () { }

    init (id: Int? = nil, response: String, promptID: Int, playerID: Int) {
        self.id = id
        self.response = response
        self.$prompt.id = promptID
        self.$player.id = playerID
    }
}



struct CreateResponse: Migration {
    func prepare ( on database: Database ) -> EventLoopFuture<Void> {
        return database.schema("responses")
          .field( "id", .int, .identifier(auto: true) )
          .field( "response", .string, .required )
          .field( "to", .int, .references("prompts", "id") )
          .field( "by", .int, .references("player", "id") )
          .create()
    }

    func revert ( on database: Database ) -> EventLoopFuture<Void> {
        return database.schema("responses").delete()
    }
}
