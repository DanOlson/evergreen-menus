source 'https://rubygems.org'

gem 'rails',        '~> 5.2.1'
gem 'pg',           '~> 0.18.0'
gem 'bcrypt',       '~> 3.1.7'
gem 'devise',       '~> 4.5.0'
gem 'cancancan',    '~> 2.2.0'
gem 'prawn',        '~> 2.2'
gem 'mailgun-ruby', '~> 1.1.6'
gem 'signet',       '~> 0.8.1'
gem 'draper',       '~> 3.0.1'
gem 'gretel',       '~> 3.0.9', github: 'DanOlson/gretel', branch: 'master'
gem 'activerecord-import', '~> 0.23.0'
gem 'money-rails',  '~> 1.11.0'
gem 'stripe',       '~> 3.17.0'
gem 'bootstrap-email', path: 'vendor/bootstrap-email'

group :development, :test do
  gem 'rspec-rails',  '~> 3.8.0'
  gem 'pry-rails',    '~> 0.3.2'
  gem 'factory_girl', '~> 4.7.0'
  gem 'faker',        '~> 1.8', github: 'stympy/faker', branch: 'master'
end

group :test do
  gem 'capybara',                 '~> 2.7.1'
  gem 'json_spec',                '~> 1.1.5'
  gem 'capybara-webkit',          '~> 1.11.1'
  gem 'vcr',                      '~> 3.0.3'
  gem 'webmock',                  '~> 2.3.0'
  gem 'launchy',                  '~> 2.4.3'
  gem 'database_cleaner',         '~> 1.7.0'
  gem 'site_prism',               '~> 2.9'
  gem 'pdf-reader',               '~> 2.0'
  gem 'timecop',                  '~> 0.9.1'
  gem 'rails-controller-testing', '~> 1.0.1'
end

group :development do
  gem 'capistrano',           '~> 3.7.1'
  gem 'capistrano-rails',     '~> 1.1', require: false
  gem 'capistrano-bundler',   '~> 1.1', require: false
  gem 'capistrano-rvm',       '~> 0.1', require: false
  gem 'capistrano-passenger', '~> 0.2', require: false
end
