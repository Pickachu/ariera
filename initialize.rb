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
require 'model/person.rb'
require 'model/point.rb'
require 'model/term.rb'
require 'model/food_establishment.rb'
require 'model/vote.rb'
require 'model/poll.rb'

# Library Items
require 'library/ariera.rb' 
require 'library/command.rb'
require 'library/action.rb'

Ariera.configuration = {
  :database => database[ENVIRONMENT], 
  :xmpp => xmpp[ENVIRONMENT]
}
                                     
