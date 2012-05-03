# Frameworks and libraries
require 'rubygems'
require 'blather'
require 'active_record'
ActiveRecord::Base # Bug on active record outside rails

# Sincronyse output
$stdout.sync = true

# Active Record Configuration
ActiveRecord::Base.establish_connection(
  :adapter  => 'mysql',
  :database => 'heitor',
  :username => 'izap',
  :password => 'WVV9974c',
  :host     => 'database.izap.com.br')

#ActiveRecord::Base.logger = Logger.new(STDERR)

# Active Record Models
require 'model/person.rb'
require 'model/point.rb'
require 'model/term.rb'
require 'model/food_establishment.rb'
require 'model/vote.rb'
require 'model/poll.rb'
require 'model/cowboy.rb'
require 'model/rule.rb'

# Library Items
require 'library/ariera.rb' 
require 'library/command.rb'
require 'library/action.rb'

autoload :Room, 'library/room'
autoload :X, 'library/stanz/xa'
