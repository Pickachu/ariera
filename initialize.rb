# TODO move this things to the initializers folder
# Frameworks and libraries     
require 'rubygems'
require 'blather'
require 'active_record'
ActiveRecord::Base # Bug on active record outside rails

# Load configurations
database = YAML::load(File.open(File.expand_path('config/database.yaml')))
xmpp = YAML::load(File.open(File.expand_path('config/xmpp.yaml')))
ENVIRONMENT = 'development'
                                               
# Syncronise output
$stdout.sync = true

# Active Record Configuration
ActiveRecord::Base.establish_connection(database[ENVIRONMENT])

#ActiveRecord::Base.logger = Logger.new(STDERR)

# Active Record Models
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

require 'ariera' 
require 'command'
require 'action'

autoload :Room, 'room'
autoload :X, 'stanz/xa'

Ariera.configuration = {
  :database => database[ENVIRONMENT], 
  :xmpp => xmpp[ENVIRONMENT]
}
