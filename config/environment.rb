# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

Rails.logger = Logger.new(STDOUT)
config.logger = ActiveSupport::Logger.new("log/#{Rails.env}.log")