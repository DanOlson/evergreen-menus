# Beer Mapper

## Development setup

### Install dependencies

QT is needed for capybara-webkit

```
brew tap homebrew/versions
brew install qt55
bundle
```

Install Passenger

```
gem install passenger --no-rdoc --no-ri
passenger-install-apache2-module
```

### Configure Apache

```
NameVirtualHost *:80

###
# Beermapper dev
<VirtualHost *:80>
  ServerName beermapper-api.dev
  ServerAlias www.beermapper-api.dev admin.beermapper.dev
  DocumentRoot /Users/dan/code/beermapper/public
  RailsEnv development
  <Directory /Users/dan/code/beermapper/public>
    Require all granted
    Options -MultiViews
  </Directory>
</VirtualHost>


<VirtualHost *:80>
  ServerName beermapper.ember
  ServerAlias www.beermapper.ember
  DocumentRoot /Users/dan/code/beermapper/ember/dist/
  <Directory /Users/dan/code/beermapper/ember/dist/>
    Require all granted
    Options -MultiViews
  </Directory>
  <Location /api/v1/>
    ProxyPass http://beermapper-api.dev/api/v1/
  </Location>
</VirtualHost>

<VirtualHost *:80>
  ServerName my-bar.dev
  ServerAlias www.my-bar.dev
  DocumentRoot /Users/dan/code/beermapper/third-party-site/public
  <Directory /Users/dan/code/beermapper/third-party-site/public>
    Require all granted
    Options -MultiViews
  </Directory>
</VirtualHost>


###
# Beermapper tests
<VirtualHost *:80>
  ServerName test.beermapper.ember
  ServerAlias www.test.beermapper.ember
  DocumentRoot /Users/dan/code/beermapper/ember/dist/
  <Directory /Users/dan/code/beermapper/ember/dist/>
    Require all granted
    Options -MultiViews
  </Directory>
  <Location /api/v1/>
    ProxyPass http://test.beermapper-api.dev/api/v1/
  </Location>
</VirtualHost>

<VirtualHost *:80>
  ServerName test.beermapper-api.dev
  ServerAlias www.test.beermapper-api.dev admin.test.beermapper.dev
  DocumentRoot /Users/dan/code/beermapper/public
  RailsEnv test
  <Directory /Users/dan/code/beermapper/public>
    Require all granted
    Options -MultiViews
  </Directory>
</VirtualHost>

<VirtualHost *:80>
  ServerName test.my-bar.dev
  ServerAlias www.test.my-bar.dev
  DocumentRoot /Users/dan/code/beermapper/third-party-site/public-test
  <Directory /Users/dan/code/beermapper/third-party-site/public-test>
    Require all granted
    Options -MultiViews
  </Directory>
</VirtualHost>
```

### Configure /etc/hosts

```
127.0.0.1 beermapper-api.dev
127.0.0.1 admin.beermapper.dev
127.0.0.1 beermapper.ember
127.0.0.1 test.beermapper-api.dev
127.0.0.1 admin.test.beermapper.dev
127.0.0.1 test.beermapper.ember
127.0.0.1 my-bar.dev
```

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
Navigate to http://admin.beermapper.dev
