require 'rubygems'
require 'blather/client'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter  => 'mysql',
  :database => 'heitor',
  :username => 'izap',
  :password => 'WVV9974c',
  :host     => 'database.izap.com.br')


require 'model/person.rb'
require 'model/point.rb'
require 'model/term.rb'


