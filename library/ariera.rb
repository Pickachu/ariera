require 'blather/client/dsl'

module Ariera
  extend Blather::DSL
                                                               
  def self.run
    authentication = configuration[:xmpp]
    setup authentication["login"], authentication['password'], authentication["host"]
    client.run                                                                   
    def client.receive_data(stanza)
      puts stanza
      super stanza
    end

  end

  when_ready do
    puts 'Connected'
    
    # include commands
    Dir["commands/*.rb"].each {|file| require_relative "../#{file}"}

    # create a room
    Room.new 'domo'
  end


  message :groupchat? do |m|
    puts 'group chat incoming'
    puts m
  end

  def self.configuration=(value)
    @configuration = value
  end                 

  def self.configuration
    @configuration
  end                   
end   
