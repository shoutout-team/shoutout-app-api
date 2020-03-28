Rake::Task['db:migrate'].enhance do
  tables = ActiveRecord::Base.connection.tables

  all_foreign_keys = tables.flat_map do |table_name|
    ActiveRecord::Base.connection.columns(table_name).map {|c| [table_name, c.name].join('.') }
  end.select { |c| c.ends_with?('_id') }

  indexed_columns = tables.map do |table_name|
    ActiveRecord::Base.connection.indexes(table_name).map do |index|
      index.columns.map {|c| [table_name, c].join('.') }
    end
  end.flatten

  unindexed_foreign_keys = (all_foreign_keys - indexed_columns)

  if unindexed_foreign_keys.any?
    warn 'WARNING: The following foreign key columns do not have an index, which can hurt performance:'
    warn unindexed_foreign_keys.join(', ')
  end
end

namespace :db do
  # rake db:reset_environment
  # NOTE: This problem occures when loading a production-dump
  desc 'Reset environment in table "ar_internal_metadata"'
  task reset_environment: :environment do
    # Shortcut-task for:
    # bin/rails db:environment:set RAILS_ENV=development
    # rake db:environment:set RAILS_ENV=development
    Rake::Task['db:environment:set'].invoke

    result = ActiveRecord::Base.connection.execute('select * from ar_internal_metadata;')
    puts result.first
  end

  # rake db:truncate
  desc 'Truncates all tables in the database'
  task truncate: :environment do
    # abort 'This task is not available in production!' if Rails.env.production?

    ARGV.each { |a| task a.to_sym do; end }
    tables = ARGV[1].try(:split, ',')
    tables = nil if tables.eql?([])
    tables ||= ActiveRecord::Base.connection.tables - ['schema_migrations', 'ar_internal_metadata']

    puts "TRUNCATE TABLES on environment #{Rails.env}: "
    puts tables.join(' | ')
    puts 'Confirm with "y"'

    abort unless $stdin.gets.chomp == 'y'

    sleep 3

    tables.each do |table|
      unless table == 'schema_migrations' || table == 'ar_internal_metadata'
        puts "Truncating now: #{table}"
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table} RESTART IDENTITY CASCADE;")
      else
        puts "Skipping table #{table}"
      end
    end
  end

  # rake db:rebuild
  task rebuild: :environment do
    Rake::Task['db:truncate'].invoke
    Rake::Task['db:seed'].invoke
  end
end
