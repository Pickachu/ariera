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
require_relative 'model/person'
require_relative 'model/point'
require_relative 'model/term'
require_relative 'model/food_establishment'
require_relative 'model/vote'
require_relative 'model/poll'
require_relative 'model/cowboy'
require_relative 'model/rule'

# Library Items
$LOAD_PATH << File.expand_path('library')

require 'blather/sasl.rb' 
require 'ariera' 
require 'command'
require 'action'

autoload :Room, 'room'
autoload :X, 'stanz/xa'

Ariera.configuration = {
  :xmpp => xmpp[ENVIRONMENT][SERVICE]
}
