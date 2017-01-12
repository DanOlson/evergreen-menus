namespace :deploy do
  task :build_dist do
    on roles(:all) do
      execute "cd #{release_path}/ember && npm install && bower install && ember build --environment=production"
    end
  end
end
