# Syncronise output
STDOUT.sync = true

# TODO move this things to the initializers folder
# Frameworks and libraries     
require 'rubygems'
require 'blather'
require 'mongoid'

# Load configurations
xmpp = YAML::load(File.open(File.expand_path('config/xmpp.yml')))

ENVIRONMENT = ENV['ENVIRONMENT']
SERVICE = ENV['SERVICE']

xmpp[ENVIRONMENT][SERVICE]['service'] = SERVICE
                                               
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
                                                               
Ariera.configuration = {
  :xmpp => xmpp[ENVIRONMENT][SERVICE],
  :mode => :room
}

# Activate debuging

case ENVIRONMENT
when 'development'
  Ariera.logger = Logger.new $stdout
  Blather.logger = Logger.new $stdout  
end
                          
