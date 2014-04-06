services_dir = File.expand_path '../../app/services', __FILE__
Dir[services_dir + '/**/*.rb'].each { |f| require f }
