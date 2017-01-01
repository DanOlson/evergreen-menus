# Beer Mapper

## Development setup

### Install dependencies

QT is needed for capybara-webkit

```
brew tap homebrew/versions
brew install qt55
bundle
```

### Configure Apache

```
###
# Beermapper dev
<VirtualHost *:80>
  ServerName beermapper-api.dev
  ServerAlias www.beermapper-api.dev
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
```

### Bundler

`bundle`
