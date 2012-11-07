require 'mongoid'

ENV['RACK_ENV'] = ENV['ENVIRONMENT'] = 'development'

# Mongoid Configuration
Mongoid.load!('config/mongoid.yml')

# Mongoid Models
require_relative 'model/point'
require_relative 'model/term'
require_relative 'model/food_establishment'
require_relative 'model/vote'
require_relative 'model/product'
require_relative 'model/point'
require_relative 'model/term'
require_relative 'model/food_establishment'
require_relative 'model/vote'
require_relative 'model/product'
require_relative 'model/purchase'
require_relative 'model/poll'
require_relative 'model/cowboy'
require_relative 'model/rule'
require_relative 'model/unhandled'
require_relative 'model/room'
