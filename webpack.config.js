'use strict'

const isProd = process.argv.indexOf('-p') !== -1
const fs = require('fs')
const path = require('path')
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')

const jsOutputFile = isProd ? 'javascripts/[name]-[hash].js' : 'javascripts/[name].js'
const cssOutputFile = isProd ? 'stylesheets/[name]-[hash].css' : 'stylesheets/[name].css'

const plugins = [
  new CopyWebpackPlugin([
    {
      from: path.join(__dirname, 'app', 'assets', 'images'),
      to: 'images/'
    }
  ]),
  new ExtractTextPlugin({
    filename: cssOutputFile
  }),

  function () {
    if (!isProd) return
    // delete previous outputs
    this.plugin('compile', function () {
      let basepath = path.join(__dirname, '/public')
      let paths = ['/javascripts', '/stylesheets']

      paths.forEach(_path => {
        const assetPath = basepath + _path

        fs.readdir(assetPath, function (err, files) {
          if (err) {
            console.error(`ERROR: ${err.message}`)
            return
          }
          if (files === undefined) {
            return
          }

          files.forEach(file => {
            fs.unlinkSync(path.join(assetPath, file))
          })
        })
      })
    })

    // output the fingerprint
    this.plugin('done', function (stats) {
      let output = 'ASSET_FINGERPRINT = "' + stats.hash + '"'
      fs.writeFileSync('config/initializers/fingerprint.rb', output, 'utf8')
    })
  }
]

module.exports = {
  mode: isProd ? 'production' : 'development',
  context: __dirname,
  entry: {
    application: './app/assets/stylesheets/application.scss',
    lists: './app/assets/javascripts/lists.js',
    'print-menus': './app/assets/javascripts/print-menus.js',
    'web-menus': './app/assets/javascripts/web-menus.js',
    'digital-display-menus': './app/assets/javascripts/digital-display-menus.js',
    'online-menu': './app/assets/javascripts/online-menu.js',
    'facebook-match-pages': './app/assets/javascripts/facebook-match-pages.js',
    'google-match-locations': './app/assets/javascripts/google-match-locations.js',
    'core-js': './app/assets/javascripts/core-js.js',
    digitalDisplay: './app/assets/stylesheets/digital_display.scss',
    facebookTab: './app/assets/stylesheets/facebook_tab.scss',
    email: './vendor/bootstrap-email/core/bootstrap-email.scss',
    marketing: './app/assets/stylesheets/marketing.scss'
  },
  output: {
    path: path.join(__dirname, '/public'),
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
          loader: 'url-loader?limit=10000&mimetype=application/font-woff'
        }
      },
      {
        test: /\.(eot|svg)(\?[a-z0-9]+)?$/,
        use: {
          loader: 'file-loader'
        }
      }
    ]
  },
  plugins,
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
}
