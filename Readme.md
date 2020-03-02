# Lawful Awful

This is a lightweight and free rendition of fill-in-the-blank party games. It is designed for people to play on their phones in their web browsers, with a head webpage open on a shared TV.

## Development Status

The game is currently under development, and is not ready to be played.

Primary development is done in Linux, which is also the deployment target. All of this *should* work on macOS, but I don't have a working copy of that system to test on.

## Setting Up for Development

To get started, you will need:

- [Swift][swinstall] (>= 5.1)
- [Node and NPM][nodinstall]

The main server library is [Vapor][vapor] 4. While Vapor provides a helper program to run your code and set up new projects, it's unnecessary and we won't be using it.

The first thing you'll need to do is create the database. Go into the project folder and run:

``` shell
swift run lawful-awful migrate
```

Now you can start the server:

``` shell
swift run lawful-awful serve -p 9292
```

Now, to bring up the frontend, we first need to install dependencies:

``` shell
npm install
```

and then start the development frontend server:

``` shell
npm run develop -- --port=8080
```

You should be able to visit `localhost:8080` in your browser and see the welcome menu. (The default port is 8080, and if that's OK for you you can leave off everything after `develop`.)

The frontend server will watch the `src/web` folder for changes and automatically recompile and refresh the page in the browser.

## Code Layout

The repo structure is based on a standard Vapor project template, merged with a node.js package format.

The main server executable is in `src/lawful-awful`. This is essentially a skeleton that loads the App library and runs the server.

The server App library itself is in `src/App`.

The web frontend lives in `src/web`. It's structured as a single-page app. Its functionality is split based on whether you're visiting as a player (usual) or as a game host connected to a TV.

If you run `npm run build`, a production-ready copy of the frontend will be placed in `dist/`.

## License

This project is distributed under the Chillbot Social License---see the `License.txt` file for the full license text. In principle, Lawful Awful is completely free and open for individuals to use, but may not be used by companies in any way.





[swinstall]: https://swift.org/download/
[nodinstall]: https://docs.npmjs.com/downloading-and-installing-node-js-and-npm
[vapor]: https://vapor.codes/
