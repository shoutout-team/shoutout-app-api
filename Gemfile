source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

def host_os_is?(regex)
  RbConfig::CONFIG['host_os'] =~ regex
end

group :core do
  gem 'bootsnap', '>= 1.4.2', require: false # Reduces boot times through caching; required in config/boot.rb
  gem 'pg'
  gem 'puma', '~> 4.1'
  gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
end

group :frontend do
  gem 'jbuilder', '~> 2.7'
  gem 'sass-rails', '>= 6'
  gem 'slim'
  gem 'slim-rails'
  gem 'turbolinks', '~> 5'
  gem 'webpacker', '~> 4.0'
end

group :backend do
end

group :utils do
  gem 'brakeman', '~> 4.3', '>= 4.3.1'
  gem 'bundler-audit'
  gem 'colorize'
  gem 'pluck_to_hash'
  gem 'require_all'
  gem 'terminal-notifier', platforms: :ruby, install_if: host_os_is?(/darwin/)
  gem 'turnout'
end

group :development, :test do
  gem 'byebug', platforms: [:mri]
  gem 'factory_bot_rails'
  gem 'pry'
  gem 'pry-alias'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'rubocop', require: false
  gem 'rubocop-rails'
end

group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rails-erd'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
