rails_env = ENV.fetch('RAILS_ENV', 'development')

namespace :ridgepole do
  desc 'Show difference *.schema between current database'
  task :'dry-run' do
    sh "ridgepole --apply --dry-run --config config/database.yml --file db/schema/Schemafile --env #{rails_env}"
  end

  desc 'Apply difference between .schema and database into database'
  task :apply do
    sh "ridgepole --apply --config config/database.yml --file db/schema/Schemafile --env #{rails_env}"
  end

end