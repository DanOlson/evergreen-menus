# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'vcr'
require Rails.root.join 'db/seeds/role_seeder'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost = true
end

Capybara::Webkit.configure do |config|
  ###
  # Beermapper Frontend
  config.allow_url("maps.googleapis.com")
  config.allow_url("maps.gstatic.com")
  config.allow_url("csi.gstatic.com")
  config.allow_url("fonts.googleapis.com")
  config.allow_url("platform.twitter.com")
  config.allow_url("builds.emberjs.com")
  config.allow_url("test.beermapper.ember")
  config.allow_url("admin.test.beermapper.dev")

  ###
  # Beermapper Admin
  config.allow_url("https://maxcdn.bootstrapcdn.com/bootstrap/latest/css/bootstrap.min.css")
end

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  config.include DeviseRequestSpecHelpers, type: :request

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before :suite do
    DatabaseCleaner.clean_with :truncation
    RoleSeeder.call
  end
  config.before :each do
    DatabaseCleaner.strategy = :transaction
  end
  config.before :each, type: :feature do
    DatabaseCleaner.strategy = :truncation, { except: %w(roles) }
  end
  config.before { DatabaseCleaner.start }
  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  config.around(:each, admin: true) do |example|
    old_app_host = Capybara.app_host
    Capybara.app_host = 'http://admin.test.beermapper.dev'
    example.run
    Capybara.app_host = old_app_host
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.infer_spec_type_from_file_location!

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  Capybara.javascript_driver = :webkit
  Capybara.app_host = ENV.fetch('TEST_APP_HOST') do
    'http://test.beermapper.ember'
  end
end
