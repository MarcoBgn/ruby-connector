require 'simplecov'
require 'coveralls'

#Simplecov is generating: TypeError: can't dup NilClass
#SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'pry-rails'
require 'factory_girl_rails'
require 'shoulda/matchers'
require 'support/helpers/api_manager_helper'
require 'support/helpers/data_helper'

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.include FactoryGirl::Syntax::Methods
end
