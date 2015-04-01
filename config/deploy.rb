require 'rvm/capistrano'
require 'bundler/capistrano'

set :application, "beermapper" # app directory name
set :repository,  "git@github.com:DanOlson/beermapper.git"

default_run_options[:pty]   = true
ssh_options[:forward_agent] = true

set :deploy_to, "/var/apps/#{application}"
set :scm, :git
set :rvm_ruby_string, 'ruby-2.1.1'
set :rvm_type,        :system
set :use_sudo,        false
set :user,            "deploy"

set :hostname,  "beermapper.com"
set :domain,    "beermapper.com"
set :branch,    "ember-cli"
set :rails_env, "production"
set :keep_releases, 3

role :web, domain
role :app, domain
role :db,  domain, primary: true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, roles: :app, except: { no_release: true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :symlink_config, roles: :app, except: { no_release: true } do
    run "rm #{release_path}/config/app_config.yml"
    run "ln -nfs #{shared_path}/config/app_config.yml #{release_path}/config/"
  end

  task :symlink_database_yml, roles: :app, except: { no_release: true } do
    run "rm #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/"
  end

  task :build_dist, roles: :app, except: { no_release: true } do
    run "cd #{release_path}/ember && ember install && ember build --environment=production"
  end
end

after 'deploy:finalize_update', 'deploy:symlink_config'
after 'deploy:finalize_update', 'deploy:symlink_database_yml'
after 'deploy:finalize_update', 'deploy:build_dist'
