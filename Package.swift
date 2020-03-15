// swift-tools-version:5.1
import PackageDescription

let package = Package(
  name: "lawful-awful",
  // platforms: [
  //    .macOS(.v10_14)
  // ],
  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-beta.3.10"),
    .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0-beta"),
    .package(url: "https://github.com/vapor/fluent-kit.git", "1.0.0-beta.3"..<"1.0.0-beta.4"),  // Pin back from beta 4 which requires Swift 5.2
    .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0-beta"),
    .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.1.0")
  ],
  targets: [
    .target(name: "App",
            dependencies: [
              "Fluent",
              "FluentKit",
              "FluentSQLiteDriver",
              "Vapor",
              "RxSwift"
            ]),
    .target(name: "lawful-awful", dependencies: ["App"]),
    .testTarget(name: "AppTests", dependencies: ["App", "XCTVapor"])
  ]
)
