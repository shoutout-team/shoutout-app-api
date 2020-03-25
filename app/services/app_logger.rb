class AppLogger
  attr_accessor :logger

  def self.init(name = :app, custom_log_file_name = nil)
    new(name, custom_log_file_name).logger
  end

  def initialize(name, custom_log_file_name)
    @log_name = name.to_s
    @custom_log_file_name = custom_log_file_name

    create_log_file

    @logger = Logger.new(log_file, 'weekly')
    @logger.formatter = Logger::Formatter.new
    @logger.progname = @log_name
  end

  def create_log_file
    return if File.exist?(log_file)

    require 'fileutils'
    FileUtils.mkdir_p(log_path)
  end

  def log_file_name
    @custom_log_file_name || @log_name
  end

  def log_path
    Rails.root.join('log', @log_name)
  end

  def log_file
    Rails.root.join('log', @log_name, "#{log_file_name}.log")
  end
end
