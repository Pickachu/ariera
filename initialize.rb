# Syncronise output
STDOUT.sync = true

# TODO move this things to the initializers folder
# Frameworks and libraries
require 'rubygems'
require 'sanitize'
require 'blather'
require 'mongoid'
require 'active_support/core_ext/date_time/calculations'

# Load configurations
xmpp = YAML::load(File.open(File.expand_path('config/xmpp.yml')))

ENVIRONMENT = ENV['ENVIRONMENT']
ACCOUNT = ENV['ACCOUNT']

# Mongoid Configuration
Mongoid.load!('config/mongoid.yml')

# Mongoid Models
require_relative 'model/point'
require_relative 'model/term'
require_relative 'model/food_establishment'
require_relative 'model/vote'
require_relative 'model/poll'
require_relative 'model/cowboy'
require_relative 'model/rule'
require_relative 'model/unhandled'
require_relative 'model/room'

# Library Items
$LOAD_PATH << File.expand_path('library')

require 'blather/sasl.rb'
require 'ariera'
require 'command'
require 'action'

autoload :Subscription, File.expand_path('model/subscription')
autoload :Person, File.expand_path('model/person')
autoload :Room, 'model/room'
autoload :X, 'stanz/xa'

Ariera.autoload :Room, File.expand_path('library/room')
# encoding: UTF-8
Ariera.autoload :Unhandled, File.expand_path('model/unhandled')
Ariera::Room.autoload :Message, File.expand_path('library/room/message')
Ariera::Room.autoload :Command, File.expand_path('library/room/command')


raise "No environment set." if ENVIRONMENT.blank?
raise "Configuration for enviroment #{ENVIRONMENT} not found." unless xmpp.has_key? ENVIRONMENT
raise "Account #{ACCOUNT} not found for enviroment #{ENVIRONMENT}." unless xmpp[ENVIRONMENT].has_key? ACCOUNT


Ariera.configuration = {
  :xmpp => xmpp[ENVIRONMENT][ACCOUNT],
  :mode => :room
}

# Activate debuging

case ENVIRONMENT
when 'development'
when 'staging'
  Ariera.logger = Logger.new $stdout
  Blather.logger = Logger.new $stdout
end
