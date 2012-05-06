require 'blather/client/dsl'

module Ariera
  extend Blather::DSL
                                                               

  def self.run
    authentication = configuration[:xmpp]
    
    puts authentication.inspect
    puts authentication.inspect
    puts authentication.inspect
    puts authentication.inspect
    puts authentication.inspect

    case authentication['service']
    when 'facebook'
      Blather::Stream::SASL::FacebookPlatform.const_set 'FB_API_KEY', authentication['api_key'] if authentication.include? 'api_key'
    end

    setup authentication["login"], authentication['password'], authentication["host"]

    client.run
  end

  when_ready do
    puts 'Connected'
    
    # include commands
    Dir["commands/*.rb"].each {|file| require_relative "../#{file}"}


    # create a room
    Room.new 'Domo'
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
