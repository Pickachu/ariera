require 'blather/client/dsl'
module Ariera
  extend Blather::DSL
                                                               
  def self.run
    authentication = configuration[:xmpp]
    setup authentication["login"], authentication['password'], authentication["host"]
    client.run                                                                   
  end
           
  when_ready do
    puts 'Connected'
    
    # include commands
    Dir["commands/*.rb"].each {|file| require file}
  end

  def self.configuration=(value)
    @configuration = value
  end                 

  def self.configuration
    @configuration
  end                   
end   
