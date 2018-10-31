# Evergreen Menus

## Development setup

### Install dependencies

QT is needed for capybara-webkit

```bash
brew tap homebrew/versions
brew install qt55
bundle
```

Install Passenger

```bash
gem install passenger --no-rdoc --no-ri
passenger-install-apache2-module
```

### Configure Apache

```xml
NameVirtualHost *:80

###
# Evergreen dev
<VirtualHost *:80>
  ServerName admin.local.evergreenmenus.com
  ServerAlias cdn.local.evergreenmenus.com
  DocumentRoot /Users/dan/code/evergreen-menus/public
  RailsEnv development
  <Directory /Users/dan/code/evergreen-menus/public>
    Require all granted
    Options -MultiViews
  </Directory>
</VirtualHost>

<VirtualHost *:80>
  ServerName my-bar.locl
  ServerAlias www.my-bar.locl
  DocumentRoot /Users/dan/code/evergreen-menus/third-party-site/public
  <Directory /Users/dan/code/evergreen-menus/third-party-site/public>
    Require all granted
    Options -MultiViews
  </Directory>
</VirtualHost>

<VirtualHost *:80>
  ServerName admin.test.evergreenmenus.com
  ServerAlias cdn.test.evergreenmenus.com
  DocumentRoot /Users/dan/code/evergreen-menus/public
  RailsEnv test
  <Directory /Users/dan/code/evergreen-menus/public>
    Require all granted
    Options -MultiViews
  </Directory>
</VirtualHost>

<VirtualHost *:80>
  ServerName test.my-bar.locl
  ServerAlias www.test.my-bar.locl
  DocumentRoot /Users/dan/code/evergreen-menus/third-party-site/public-test
  <Directory /Users/dan/code/evergreen-menus/third-party-site/public-test>
    Require all granted
    Options -MultiViews
  </Directory>
</VirtualHost>
```

### Configure /etc/hosts

```
127.0.0.1 admin.local.evergreenmenus.com
127.0.0.1 cdn.local.evergreenmenus.com
127.0.0.1 admin.test.evergreenmenus.com
127.0.0.1 cdn.test.evergreenmenus.com
127.0.0.1 my-bar.locl
```

### Additionally, setup local SSL support in Apache with these instructions

https://gist.github.com/jonathantneal/774e4b0b3d4d739cbc53

### Restart Apache

```
sudo apachectl configtest
sudo apachectl restart
```

### Bundler

`bundle`

### Node

```
brew install nvm
nvm install 10.11.0
npm i
```

### Bootstrap

```
rake db:bootstrap --trace
webpack --watch
```

### Run Tests

`bundle exec rspec spec`

### Go

Navigate to http://admin.evergreen-menus.locl

## Development Workflows

### Adding new menu item icons (dietary restrictions, etc.)

We've been getting icons from [The Noun Project](https://thenounproject.com) and converting them to web fonts with [Glyphter](https://glyphter.com/). Assuming you want to add more, you can download the SVGs, upload them to Glyphter, download the fonts from Glyphter and replace the Glyphter.* files in app/assets/fonts with the newly downloaded replacements. This amounts to a  nuke-and-pave scenario, where you'll lose any icons you don't upload to Glyphter. To mitigate this, all the existing SVGs are in app/assets/images and can be uploaded to Glyphter along with any new SVGs form which you want to make fonts. Lastly, you'll need to edit app/assets/stylesheets/_icons.scss to add new entries from the downloaded CSS file from Glyphter

Current food intolerance icons were from:
https://thenounproject.com/olguioo/collection/food-intolerances/?i=979944

## Deployment

Capistrano is used for deploys. We build all the front end assets locally, then commit them on a dedicated branch where they're tracked by Git. We then tag the repo where we built the assets and push everything to the remote. We use Capistrano to deploy that tag. The benefit of this approach is we don't have to tie up the CPU of the production servers building assets. We can simply pull a git repo where the assets are already built and be off to the races.

Workflow:

```bash
# Run the build script from the master branch.
# This will checkout the 'build' branch, build assets,
# commit, tag, push, and checkout master again.
./build.sh

# The last line of the build script is the tag name to deploy
# It looks like "build-XX", where XX is a number.
RELEASE_VERSION=build-10 cap [staging|production] deploy
```
