import Foundation



extension String {
    static func base64Random(_ bytes: Int) -> String {
        return Data( (0..<bytes).map { _ in UInt8.random(in: 0...255) } )
          .base64EncodedString()
    }



    static func randomChars(_ count: Int, from letters: String) -> String {
        return String( (0..<count).map { _ in letters.randomElement()! } )
    }
}
