source 'https://rubygems.org'
ruby '2.2.3'

gem 'rails', '4.2.4'
gem 'haml-rails'
gem 'bootstrap-sass'
gem 'autoprefixer-rails', '6.3.7'
gem 'maestrano-connector-rails', '1.2.2'
gem 'turbolinks'
gem 'jquery-rails'
gem 'coffee-rails'
gem 'puma'
gem 'figaro'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :jruby]
gem 'uglifier', '>= 1.3.0'
gem 'config'
gem 'attr_encrypted', '~> 1.4.0'

gem 'sinatra', require: nil
gem 'sidekiq', '4.1.4'
gem 'sidekiq-cron'
gem 'slim'

gem 'rdoc', '~> 3.12'
gem 'jeweler', '~> 2.1.1'

gem 'oauth2'
gem 'basecrm'

group :production, :uat do
  gem 'activerecord-jdbcpostgresql-adapter', platforms: :jruby
  gem 'pg', platforms: :ruby
  gem 'rails_12factor'
end

group :test, :develpment do
  gem 'activerecord-jdbcsqlite3-adapter', platforms: :jruby
  gem 'sqlite3', platforms: :ruby
end

group :test do
  gem 'simplecov'
  gem 'coveralls', require: false
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'timecop'
end
