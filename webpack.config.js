let path = require('path');

let BUILD_DIR = path.resolve(__dirname, 'javascript/public');
let APP_DIR = path.resolve(__dirname, 'javascript/list_app');

let config = {
  entry: APP_DIR + '/index.js',
  output: {
    path: BUILD_DIR,
    filename: 'bundle.js'
  },
  module: {
    rules: [
      {
        test: /\.jsx?/,
        include: APP_DIR,
        loader: 'babel-loader',

      },
      {
        test: /\.css$/,
        loader:'style-loader!css-loader'
}
    ]
  }
};

module.exports = config;
