const path = require('path');
const HTMLWebpackPlugin = require('html-webpack-plugin');



const babelConfig = {
  presets: [
    '@babel/preset-env',
  ],

  plugins: [
    ['@babel/plugin-transform-runtime', { corejs: 3 }],
    "@babel/plugin-transform-react-jsx",
  ],
};

const devServer = {
  contentBase: './dist/web',
  proxy: {
    '/api': {
      target: 'http://localhost:9292',
      pathRewrite: {'^/api': ''},
    },
  },
};



module.exports = {
  entry: "./src/web/index.js",
  output: {
    path: path.resolve(__dirname, 'dist/web'),
    filename: "[name]-[contenthash].js",
  },
  devtool: "source-map",
  devServer,
  optimization: {
    splitChunks: {
      chunks: "all",
    },
  },
  module: {
    rules: [

      { test: /\.js$/,
        exclude: /node_modules/,
        use: { loader: "babel-loader",
               options: babelConfig }},

    ],
  },
  plugins: [
    new HTMLWebpackPlugin({
      title: "Lawful Awful",
    }),
  ],
};
