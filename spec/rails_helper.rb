ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'devise'
require 'support/controller_macros'
require 'support/share_db_connection'
require 'database_cleaner'

require 'capybara/rails'
require 'capybara/rspec'

DatabaseCleaner.strategy = :truncation

ActiveRecord::Migration.maintain_test_schema!

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.include Rails.application.routes.url_helpers

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.include FactoryGirl::Syntax::Methods

  config.include Devise::TestHelpers, type: :controller

  config.extend ControllerMacros, :type => :controller

  config.include Warden::Test::Helpers

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
