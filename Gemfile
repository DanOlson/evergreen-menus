source 'https://rubygems.org'

gem 'rails',                    '>= 5.0.0.1', '< 5.1'
gem 'pg',                       '~> 0.18.0'
gem 'bcrypt',                   '~> 3.1.7'
gem 'geocoder',                 '~> 1.1.8'
gem 'active_model_serializers', '~> 0.8.1'
gem 'beer_list', git: 'git@github.com:DanOlson/beer_list.git', branch: '2.0'
gem 'kaminari',                 '~> 0.15.1'
gem 'newrelic_rpm'
gem 'logvisible'
gem 'responders',               '~> 2.1.1'
gem 'whenever',                 '~> 0.9.7', require: false
gem 'devise',                   '~> 4.2.0'
gem 'cancancan',                '~> 1.15.0'
gem 'prawn',                    '~> 2.2'
gem 'mailgun-ruby',             '~> 1.1.6'

group :development, :test do
  gem 'rspec-rails',  '~> 3.5.0'
  gem 'pry-rails',    '~> 0.3.2'
  gem 'factory_girl', '~> 4.7.0'
  gem 'faker',        '~> 1.6.6'
end

group :test do
  gem 'capybara',         '~> 2.7.1'
  gem 'capybara-webkit',  '~> 1.11.1'
  gem 'vcr',              '~> 3.0.3'
  gem 'webmock',          '~> 2.3.0'
  gem 'launchy',          '~> 2.4.3'
  gem 'database_cleaner', '~> 1.5.3'
  gem 'site_prism',       '~> 2.9'
  gem 'pdf-reader',       '~> 2.0'
end

group :development do
  gem 'capistrano',           '~> 3.7.1'
  gem 'capistrano-rails',     '~> 1.1', require: false
  gem 'capistrano-bundler',   '~> 1.1', require: false
  gem 'capistrano-rvm',       '~> 0.1', require: false
  gem 'capistrano-passenger', '~> 0.2', require: false
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
