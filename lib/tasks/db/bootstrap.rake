namespace :db do
  desc 'db:drop db:create db:migrate db:seed -- bootstrap!'
  task bootstrap: [:drop, :create, :migrate, :seed]
end
