#--------------------------------------------------------------------------------
# NOTE: when changing migrations do not forget to run: rake db:test:prepare
#--------------------------------------------------------------------------------

ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/pride'
require 'minitest-optional_retry'

if RUBY_PLATFORM.match?(/darwin/)
  require 'minitest/autorun'
  require 'minitest/macos_notification'
  require 'minitest/reporters'

  Minitest::Reporters.use!(
    [
      Minitest::Reporters::SpecReporter.new,
      Minitest::Reporters::MacosNotificationReporter.new(title: 'Shoppyr-Tests')
    ],
    ENV,
    Minitest.backtrace_filter
  )
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    # parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    # fixtures :all

    # Add more helper methods to be used by all tests here...
    include FactoryBot::Syntax::Methods
  end
end
