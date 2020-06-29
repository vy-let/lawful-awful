// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "lawful-awful",

  products: [
    .executable( name: "lawful-awful", targets: ["lawful-awful"] )
  ],

  dependencies:
    [ .package(url: "https://github.com/vapor/vapor.git", from: "4.14.0")
    , .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0")
    , .package(url: "https://github.com/vapor/fluent-kit.git", from: "1.0.2")
    , .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0-rc.2")
  ],

  targets: [

    .target(
      name: "App",
      dependencies:
        [ .product( name: "Vapor", package: "vapor" )
        , .product( name: "Fluent", package: "fluent" )
        , .product( name: "FluentKit", package: "fluent-kit" )
        , .product( name: "FluentSQLiteDriver", package: "fluent-sqlite-driver" )
        ]
    ),

    .target(
      name: "lawful-awful",
      dependencies: [ "App" ]),

    .testTarget(
      name: "lawful-awfulTests",
      dependencies: [ "lawful-awful" ]),

  ]
)
