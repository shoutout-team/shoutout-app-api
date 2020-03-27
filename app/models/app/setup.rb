# rubocop:disable Layout/LineLength
module App
  class Setup
    def initialize(app_name, local_seeds: false)
      @app_name = app_name
      @env = Rails.env
      @local_seeds = local_seeds
    end

    def self.call(app_name, method: :perform, local_seeds: false)
      new(app_name, local_seeds: local_seeds).tap(&method)
    end

    def perform
      check_environment!
      migrate_database
      create_root_account!
      process_seeds
    end

    def process_seeds
      content = load_seeds
      process_admins(content)
      process_users(content) if development? || preview?
      process_companies(content) if development? || preview?
      map_keepers_to_companies if development? || preview?
      # TODO: disabled :process_locations in setup #42
      #process_locations
    end

    def check_environment!
      check_database!
      check_env_vars!
      truncate if development? || preview?
      check_data_state!
    end

    def migrate_database
      Rake::Task['db:migrate'].invoke
    end

    def create_root_account!
      email = fetch_env_var(:app_root_user)
      password = fetch_env_var(:app_root_pwd)
      User.create!(role: :root, name: 'Shoutout', email: email, password: password, approved: true, confirmed_at: Time.zone.now)
    end

    private def check_database!
      raise 'NoDatabase' unless ActiveRecord::Base.connection.table_exists?(:ar_internal_metadata)
    end

    private def truncate
      ARGV[1] = ''
      Rake::Task['db:truncate'].invoke if development? || preview?
    end

    private def check_data_state!
      raise 'NotApplicable' if User.any?
    end

    private def check_env_vars!
      required_env_vars.map(&:upcase).each do |env_var_name|
        raise "environment variable '#{env_var_name}' undefined" if fetch_env_var(env_var_name).blank?
      end
    end

    private def required_env_vars
      %w[app_environment app_root_user app_root_pwd app_seed_url app_seed_dev_url].freeze
    end

    private def fetch_env_var(name)
      name = "#{@app_name}_#{name}" if development? && @app_name.present?
      ENV[name.to_s.upcase] # NOTE: Weird, on heroku it crashes when not calling explicitly :to_s
    end

    # rubocop:disable Security/YAMLLoad
    # YAML.safe_load does not work with symbols in yaml-file!
    private def load_seeds
      yaml_content = @local_seeds ? load_seeds_from_path : load_seeds_from_url
      yaml_data = YAML.load(yaml_content)
      yaml_data.deep_symbolize_keys!
    end
    # rubocop:enable Security/YAMLLoad

    private def seed_url
      development? || preview? ? fetch_env_var(:app_seed_dev_url) : fetch_env_var(:app_seed_url)
    end

    private def load_seeds_from_path
      file_name = development? || preview? ? 'seeds_dev.yml' : 'seeds.yml'
      File.open(Rails.root.join("tmp/seeds/#{file_name}"))
    end

    # rubocop:disable Security/Open
    # This is OK for this task!
    private def load_seeds_from_url
      require 'open-uri'
      open(seed_url, http_basic_authentication: [@app_name, fetch_env_var(:app_root_pwd)], &:read)
    end
    # rubocop:enable Security/Open

    private def development?
      @env.eql?('development')
    end

    private def preview?
      fetch_env_var(:app_environment).to_sym.eql?(:preview)
    end

    def process_admins(content)
      content[:seeds][:admins].each do |attrs|
        User.create!(attrs.merge(confirmed_at: Time.zone.now))
      end
    end

    def process_users(content)
      content[:seeds][:users].each do |attrs|
        User.create!(attrs.merge(confirmed_at: Time.zone.now))
      end
    end

    def process_companies(content)
      user = User.root.first
      default_properties = content[:seeds][:company_properties]

      content[:seeds][:companies].each do |attrs|
        Company.create!(attrs.merge(user: user, properties: default_properties))
      end
    end

    def map_keepers_to_companies
      companies = Company.order(:id).all

      User.keepers.order(:id).limit(companies.size).each_with_index do |user, index|
        companies[index].update(user: user)
      end
    end

    def process_locations
      require 'csv'

      file_path = Rails.root.join('public/data/zuordnung_plz_ort.csv')

      CSV.foreach(file_path, headers: true) do |row|
        Location.create!(name: row['ort'], postcode: row['plz'], federate_state: row['bundesland'], osm_id: row['osm_id'].to_i)
      end
    end
  end
end
# rubocop:enable Layout/LineLength
