ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
# as our base helper
require 'spec_helper'
# for rails
require 'rspec/rails'
# for generating test coverage
require 'simplecov'
# for tracking test coverage on
# https://coveralls.io/github/openSUSE/open-build-service
require 'coveralls'

# check for pending migration and apply them before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # load ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # run each example within a transaction
  config.use_transactional_fixtures = true

  # set spec type based on their file location
  config.infer_spec_type_from_file_location!

  # filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end

# support test coverage
require 'support/coverage'

# support fixtures
require 'support/factory_girl'

# support Suse::backend
require 'support/backend'

# support controllers authentification
require 'support/controllers/authentification'
