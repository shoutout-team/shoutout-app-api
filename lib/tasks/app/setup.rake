namespace :app do
  namespace :setup do
    # rake app:setup:run shoutout
    task run: :environment do
      ARGV.each { |a| task a.to_sym do; end }

      raise 'no name for application given' if ARGV[1].blank?

      App::Setup.call(ARGV[1])
    end
  end
end
