module App
  module Setup
    def self.check_environment!(app_name)
      check_database!
      #check_data_state! # TODO: Enable check_data_state! #32
      check_env_vars!(app_name)
    end

    def self.create_root_account!
      email = ENV['APP_ROOT_USER']
      password = ENV['APP_ROOT_PWD']
      User.create!(email: email, password: password, approved: true, confirmed_at: Time.zone.now)
    end

    def self.process_seeds!
      content = load_seeds
      process_users(content)
    end

    def self.process_users(content)
      content[:seeds][:users].each do |attrs|
        User.create!(attrs)
      end
    end

    def self.load_seeds
      require 'open-uri'

      yaml_content = open(seed_url) { |f| f.read }
      yaml_data = YAML::load(yaml_content)
      yaml_data.deep_symbolize_keys!
    end

    def self.check_database!
      ActiveRecord::Base.connection.table_exists?(:ar_internal_metadata)
    end

    def check_data_state
      raise 'setup already performed' if User.any?
    end

    def self.check_env_vars!(app_name)
      env_vars.map(&:upcase).each do |env_var_name|
        raise "environment variable '#{env_var_name}' undefined" if fetch_env_var(env_var_name, app_name).blank?
      end
    end

    def self.env_vars
      %w[app_environment app_root_user app_root_pwd app_seed_url app_seed_dev_url].freeze
    end

    def self.fetch_env_var(name, app_name = :shoutout)
      name = "#{app_name}_#{name}" if Rails.env.development? && app_name.present?
      ENV[name.upcase]
    end

    def self.seed_url
      Rails.env.development? ? fetch_env_var(:app_seed_dev_url) : fetch_env_var(:app_seed_url)
    end
  end
end
