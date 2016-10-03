source 'https://rubygems.org'

gem 'rails',                    '>= 5.0.0.rc1', '< 5.1'
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

group :development, :test do
  gem "rspec-rails", "3.5.0.beta3"
  gem 'pry-rails',   '~> 0.3.2'
end

group :development do
  gem 'rvm-capistrano', '~> 1.4.3'
  gem 'capistrano',     '~> 2.15.5'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
