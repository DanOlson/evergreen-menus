namespace :deploy do
  namespace :assets do
    task :precompile do
      ###
      # overwrite Sprockets' task to use Webpack instead
      on roles(:all) do
        build_flag = %w(production staging).include?(fetch(:rails_env)) ? '-p' : ''
        execute "cd #{release_path} && npm install && ./node_modules/.bin/webpack --progress --colors -p"
      end
    end
  end
end
