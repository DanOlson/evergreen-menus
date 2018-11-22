# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'vcr'
require 'webmock/rspec'
require Rails.root.join 'db/seeds/role_seeder'
require Rails.root.join 'lib/services/third_party_site_generator'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

Prawn::Font::AFM.hide_m17n_warning = true

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost = true
  c.ignore_request do |req|
    ###
    # Requests for testing PDF and display previews
    req.uri['menu_preview.pdf'] ||
    req.uri['/digital_display_menu_preview?'] ||
    req.uri['/web_menu_preview?'] ||
    req.uri['/online_menu_preview?'] ||
    req.uri['/rails/active_storage/']
  end
end

Capybara::Webkit.configure do |config|
  config.allow_url("fonts.googleapis.com")
  config.allow_url("admin.test.evergreenmenus.com")
  config.allow_url("cdn.test.evergreenmenus.com")
  config.allow_url("test.my-bar.locl")
  config.allow_url("stackpath.bootstrapcdn.com")
  config.allow_url("use.fontawesome.com")
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
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include AuthenticationHelper, type: :feature

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
    Capybara.app_host = 'http://admin.test.evergreenmenus.com'
    example.run
    Capybara.app_host = old_app_host
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.infer_spec_type_from_file_location!

  config.example_status_persistence_file_path = 'tmp/rspec-examples.txt'

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  Capybara.javascript_driver = :webkit
end

# https://github.com/ruby/ruby/commit/a43f2cbaa11c792cf417c6400d76710df77cd125
# Fix Ripper.lex error in dedenting squiggly heredoc
require 'ripper'
Ripper::Lexer.class_eval do
  def on_heredoc_dedent(v, w)
    @buf.last.each do |e|
      if e.event == :on_tstring_content
        if (n = dedent_string(e.tok, w)) > 0
          e.pos[1] += n
        end
      end
    end
    v
  end
end
