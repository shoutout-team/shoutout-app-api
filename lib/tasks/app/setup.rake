namespace :app do
  namespace :setup do
    # rake app:setup:run
    task run: :environment do
      app_name = :shoutout

      #Rake::Task['db:truncate'].invoke if Rails.env.development?

      App::Setup.check_environment!(app_name)
      Rake::Task['db:migrate'].invoke
      #App::Setup.create_root_account!
      App::Setup.process_seeds!
    end
  end
end
