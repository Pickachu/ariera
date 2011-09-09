
# Frameworks and libraries
require 'rubygems'
require 'blather/client'
require 'active_record'


# Active Record Configuration
ActiveRecord::Base.establish_connection(
  :adapter  => 'mysql',
  :database => 'heitor',
  :username => 'izap',
  :password => 'WVV9974c',
  :host     => 'database.izap.com.br')

ActiveRecord::Base.logger = Logger.new(STDERR)

# Active Record Models
require 'model/person.rb'
require 'model/point.rb'
require 'model/term.rb'
require 'model/food_establishment.rb'
require 'model/vote.rb'



