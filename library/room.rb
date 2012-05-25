module Ariera
  class Room
    # Move to module Ariera::Client::DSL
    delegate :message, :write_to_stream, :my_roster, :logger, :to => Ariera 
    alias_method :roster, :my_roster
          
    delegate :identity, :to => :room
    attr_accessor :room, :people

    def initialize identity
      logger.debug "initialzing room #{identity}"
      @room = ::Room.find_or_create_by :identity => identity

      initialize_people
      listen
      autoaprove
    end
     
    def receive message
      if in_room? message.sender
        person = people[message.sender]

        puts message.inspect
                     
        unless message.kind_of? Command
          message.body = "[#{message.pseudonym}] #{message.body}" # Prefix with sender name
        end                                                                     

        message.broadcast
      else
        reply = message.reply
        reply.body = "Voce nao esta na sala safadinho!"
        reply.deliver
      end 
    end

    def in_room? identity
      people[identity.to_s]
    end

    # Listening methods
    def listen
      Ariera.message :chat?, :body do |message|
        receive Ariera::Room::Message.new(self, message)
      end                                 
    end

    def add person
      @people[person.identity] = person
      @room.people << person
      @room.save
    end
        
    def autoaprove
      Ariera.subscription :request? do |s|
        listed = Person.where(:identity => s.from).first
        if (listed)
          logger.debug "approved subscription request from #{s.from}"
          add listed                     
          write_to_stream s.approve!
        else
          logger.debug "ignored chat request from #{s.from}"
        end             
      end
    end

    def initialize_people
      @people = {}

      @room.people.map do |person| 
        @people[person.identity] = person.name
        
        # Update nickname of people
        item = roster[person.identity]
        if (item.name != person.nickname)
          item.name = person.nickname
          roster.push item
        end
      end

      logger.debug "people in room are #{@people.values.join(', ')}"
    end
  end
end
