require 'simplecov'
require File.expand_path("../../config/environment", __FILE__)



require 'rspec/rails'

require File.dirname(__FILE__) + '/../config/application.rb'

require File.dirname(__FILE__) + '/../matchers/have_hash_values.rb'
require File.dirname(__FILE__) + '/../matchers/be_loaded_with.rb'

Blueprints.enable do |config|
  config.transactions = true
  config.prebuild = :city
end

RSpec.configure do |config|
  config.mock_with :mocha
  config.use_transactional_fixtures = false
  config.after do
    Timecop.return
  end
end


RSpec.configure do |config|  
  config.include(Matchers)  
end

