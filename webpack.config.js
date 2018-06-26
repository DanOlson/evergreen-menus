'use strict';

const isProd  = process.argv.indexOf('-p') !== -1;
const fs      = require('fs');
const path    = require('path');
const webpack = require('webpack');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const jsOutputFile  = isProd ? 'javascripts/[name]-[hash].js' : 'javascripts/[name].js';
const cssOutputFile = isProd ? 'stylesheets/[name]-[hash].css' : 'stylesheets/[name].css';

const plugins = [
  new CopyWebpackPlugin([
    {
      from: path.join(__dirname, 'app', 'assets', 'images'),
      to: 'images/'
    }
  ]),
  new CopyWebpackPlugin([
    {
      from: path.join(__dirname, 'app', 'assets', 'font-awesome-4.7.0/css'),
      to: 'font-awesome/css'
    }
  ]),
  new CopyWebpackPlugin([
    {
      from: path.join(__dirname, 'app', 'assets', 'font-awesome-4.7.0/fonts'),
      to: 'font-awesome/fonts'
    }
  ]),
  new ExtractTextPlugin({
    filename: cssOutputFile
  }),

  function() {
    if (!isProd) return;
    // delete previous outputs
    this.plugin("compile", function() {
      let basepath = __dirname + "/public";
      let paths = ["/javascripts", "/stylesheets"];

      paths.forEach(path => {
        const asset_path = basepath + path;

        fs.readdir(asset_path, function(err, files) {
          if (files === undefined) {
            return;
          }

          files.forEach(file => {
            fs.unlinkSync(asset_path + "/" + file);
          })
        });
      })
    });

    // output the fingerprint
    this.plugin("done", function(stats) {
      let output = "ASSET_FINGERPRINT = \"" + stats.hash + "\""
      fs.writeFileSync("config/initializers/fingerprint.rb", output, "utf8");
    });
  }
]

module.exports = {
  mode: isProd ? 'production' : 'development',
  context: __dirname + '/app/assets',
  entry: {
    application: './stylesheets/application.scss',
    lists: './javascripts/lists.js',
    'print-menus': './javascripts/print-menus.js',
    'web-menus': './javascripts/web-menus.js',
    'digital-display-menus': './javascripts/digital-display-menus.js',
    'online-menu': './javascripts/online-menu.js',
    'core-js': './javascripts/core-js.js',
    digitalDisplay: './stylesheets/digital_display.scss',
    facebookTab: './stylesheets/facebook_tab.scss',
  },
  output: {
    path: __dirname + '/public',
    filename: jsOutputFile
  },
  devtool: 'source-map',
  module: {
    rules: [
      {
        test: /\.js$/,
        include: path.join(__dirname, 'app', 'assets', 'javascripts'),
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['env', 'react']
          }
        }
      },
      {
        test: /\.scss$/,
        use: ExtractTextPlugin.extract(['css-loader', 'sass-loader'])
      },
      {
        test: /\.(ttf|woff(2)?)(\?[a-z0-9]+)?$/,
        use: {
          loader: "url-loader?limit=10000&mimetype=application/font-woff"
        }
      },
      {
        test: /\.(eot|svg)(\?[a-z0-9]+)?$/,
        use: {
          loader: "file-loader"
        }
      }
    ]
  },

  plugins: plugins,

  optimization: {
    splitChunks: {
      cacheGroups: {
        commons: {
          test: /[\\/]node_modules[\\/]/,
          name: 'vendor',
          chunks: 'all'
        }
      }
    }
  }
};
