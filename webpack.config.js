const isProd = process.env.RAILS_ENV === 'production'
const path = require('path');

module.exports = {
  entry: {
    application: './app/assets/javascripts/application.js'
  },
  output: {
    path: './public/javascripts',
    filename: isProd ? 'bundle-[hash].js' : 'bundle.js'
  },
  devtool: 'sourcemap',
  module: {
    loaders: [{
      test: /\.js$/,
      loader: 'babel-loader',
      include: path.join(__dirname, 'app', 'assets', 'javascripts'),
      query: {
        presets: ['es2015', 'react']
      }
    }]
  }
};
