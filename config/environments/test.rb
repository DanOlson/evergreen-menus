environment_url_options = {
  host: 'admin.test.evergreenmenus.com',
  protocol: 'http'
}

EvergreenMenus::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = false

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure static asset server for tests with Cache-Control for performance.
  config.serve_static_assets  = true
  config.public_file_server.headers = { 'Cache-Control' => 'public, max-age=3600' }
  config.assets.debug = false
  config.assets.compile = false
  config.assets.quiet = true

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # config.default_url_options = environment_url_options

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = true

  config.action_mailer.default_url_options = environment_url_options

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test
  config.action_mailer.preview_path = Rails.root.join('spec/mailers/previews')

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # config.log_level = :debug
  config.active_storage.service = :test
end

Rails.application.routes.default_url_options.merge!(environment_url_options)
