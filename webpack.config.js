'use strict';

const isProd = process.argv.indexOf('-p') !== -1;
const fs     = require('fs');
const path   = require('path');
const ExtractTextPlugin = require('extract-text-webpack-plugin');

const jsOutputFile  = isProd ? 'javascripts/bundle-[hash].js' : 'javascripts/bundle.js';
const cssOutputFile = isProd ? 'stylesheets/[name]-[hash].css' : 'stylesheets/[name].css';

module.exports = {
  context: __dirname + '/app/assets',
  entry: {
    application: ['./javascripts/application.js', './stylesheets/application.scss']
  },
  output: {
    path: __dirname + '/public',
    filename: jsOutputFile
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
    },{
      test: /\.scss$/,
      loader: ExtractTextPlugin.extract('style-loader', 'css-loader')
    }]
  },

  plugins: [
    new ExtractTextPlugin(cssOutputFile),

    function() {
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
};
