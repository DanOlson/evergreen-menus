namespace :deploy do
  namespace :assets do
    task :precompile do
      ###
      # overwrite Sprockets' task to use Webpack instead
      on roles(:all) do
        execute "cd #{release_path} && npm install && ./node_modules/.bin/webpack --progress --colors"
      end
    end
  end
end
