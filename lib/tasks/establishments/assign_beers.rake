namespace :establishments do

  desc 'Set establishment_id on beers based on beer_establishment relationship'
  task assign_beers: :environment do
    sql = <<-SQL
      with establishment_beers as (
        select nextval('beers_id_seq') as id
              ,beers.name as name
              ,beers.created_at as created_at
              ,now() as updated_at
              ,beer_establishments.establishment_id as establishment_id
        from beers
        join beer_establishments
          on beers.id = beer_establishments.beer_id
      )
      insert into beers
      select * from establishment_beers;
    SQL

    ActiveRecord::Base.connection.execute sql
  end
end
