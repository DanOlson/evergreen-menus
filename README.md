# Beer Mapper

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
# Beermapper dev
<VirtualHost *:80>
  ServerName beermapper-api.locl
  ServerAlias www.beermapper-api.locl admin.evergreenmenus.locl cdn.evergreenmenus.locl
  DocumentRoot /Users/dan/code/beermapper/public
  RailsEnv development
  <Directory /Users/dan/code/beermapper/public>
    Require all granted
    Options -MultiViews
  </Directory>
</VirtualHost>

<VirtualHost *:80>
  ServerName my-bar.locl
  ServerAlias www.my-bar.locl
  DocumentRoot /Users/dan/code/beermapper/third-party-site/public
  <Directory /Users/dan/code/beermapper/third-party-site/public>
    Require all granted
    Options -MultiViews
  </Directory>
</VirtualHost>

<VirtualHost *:80>
  ServerName test.beermapper-api.locl
  ServerAlias www.test.beermapper-api.locl admin.test.evergreenmenus.locl cdn.test.evergreenmenus.locl
  DocumentRoot /Users/dan/code/beermapper/public
  RailsEnv test
  <Directory /Users/dan/code/beermapper/public>
    Require all granted
    Options -MultiViews
  </Directory>
</VirtualHost>

<VirtualHost *:80>
  ServerName test.my-bar.locl
  ServerAlias www.test.my-bar.locl
  DocumentRoot /Users/dan/code/beermapper/third-party-site/public-test
  <Directory /Users/dan/code/beermapper/third-party-site/public-test>
    Require all granted
    Options -MultiViews
  </Directory>
</VirtualHost>
```

### Configure /etc/hosts

```
127.0.0.1 admin.evergreenmenus.locl
127.0.0.1 cdn.evergreenmenus.locl
127.0.0.1 admin.test.evergreenmenus.locl
127.0.0.1 cdn.test.evergreenmenus.locl
127.0.0.1 my-bar.locl
```

### Setup Beermapper Frontend

Follow the instructions for [setting up Beermapper](https://github.com/DanOlson/beermapper-frontend)

The bits about Apache and hosts file entries are important. You'll also need to install and build:

`~/code/beermapper-frontend $ npm install && bower install && ember build`

### Restart Apache

`sudo apachectl restart`

### Bundler

`bundle`

### Node

```
brew install nvm
nvm install 6.3.1
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

Navigate to http://beermapper.ember
Navigate to http://admin.beermapper.locl
