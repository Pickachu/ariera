require 'blather/client/dsl'

module Ariera
  extend Blather::DSL

  class << self
    # TODO create attr_accessor only if we're in room mode
    attr_accessor :configuration, :logger, :room
  end

  @logger = Logger.new $stderr

  def self.run
    authentication = configuration[:xmpp]

    # logger.level = Logger::DEBUG

    case authentication['service']
    when 'facebook'
      Blather::Stream::SASL::FacebookPlatform.const_set 'FB_API_KEY', authentication['api_key'] if authentication.include? 'api_key'
    end

    setup authentication["login"] + '/Ariera', authentication['password'], authentication["host"]

    client.run
  end

  def self.instance
    client
  end

  def self.clear_handlers *args
    client.clear_handlers *args
  end

  when_ready do
    Ariera.logger.info('when_ready') {"connected as #{jid}"}

    # include commands
    Dir["commands/*.rb"].each {|file| require_relative "../#{file}"}
    Dir["commands/room/*.rb"].each {|file| require_relative "../#{file}"}

    # create a room
    if configuration[:mode] == :room
      self.room = Room.new 'chat@izap.com.br'
    end

    # listen for unhandled commands
    Unhandled.new
  end
end
