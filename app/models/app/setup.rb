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

    def check_environment!
      check_database!
      check_env_vars!
      # TODO: Enable :truncate and :check_data_state! #32
      #truncate if development?
      #check_data_state!
    end

    def migrate_database
      Rake::Task['db:migrate'].invoke
    end

    def create_root_account!
      email = fetch_env_var(:app_root_user)
      password = fetch_env_var(:app_root_pwd)
      User.create!(role: :root, name: 'Shoutout', email: email, password: password, approved: true, confirmed_at: Time.zone.now)
    end

    def process_seeds
      content = load_seeds
      process_users(content)
    end

    private def check_database!
      raise 'NoDatabase' unless ActiveRecord::Base.connection.table_exists?(:ar_internal_metadata)
    end

    private def truncate
      Rake::Task['db:truncate'].invoke if development?
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
      ENV[name.upcase]
    end

    private def load_seeds
      yaml_content = @local_seeds ? load_seeds_from_path : load_seeds_from_url
      yaml_data = YAML::load(yaml_content)
      yaml_data.deep_symbolize_keys!
    end

    private def seed_url
      development? ? fetch_env_var(:app_seed_dev_url) : fetch_env_var(:app_seed_url)
    end

    private def load_seeds_from_path
      file_name = development? ? 'seeds_dev.yml' : 'seeds.yml'
      File.open(Rails.root.join("tmp/seeds/#{file_name}"))
    end

    private def load_seeds_from_url
      require 'open-uri'
      open(seed_url) { |f| f.read }
    end

    private def development?
      @env.eql?('development')
    end

    def process_users(content)
      content[:seeds][:users].each do |attrs|
        User.create!(attrs)
      end
    end
  end
end
