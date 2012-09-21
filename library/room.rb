# encoding: utf-8
module Ariera
  class Room
    # Move to module Ariera::Client::DSL
    delegate :message, :write_to_stream, :my_roster, :logger, :shell, :to => Ariera
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

    def receive stanza
      if in_room? stanza.sender
        person = people[stanza.sender]

        # Prefix with sender name unless is a command
        unless stanza.kind_of? Command
          stanza.body = "[#{stanza.pseudonym}] #{stanza.body}"
          stanza.formatted_body = "<span style=\"color: #666666;\"><b>#{stanza.pseudonym}</b></span>: #{stanza.formatted_body}" # Prefix with sender name
        end

        stanza.broadcast
      else
        reply = stanza.reply
        reply.body = "Voce não está na sala safadinho!"
        reply.formatted_body = "Voce não está na sala safadinho!"
        reply.deliver
      end
    end

    def in_room? identity
      people[identity.to_s]
    end

    # Listening methods
    # TODO move this to a command
    # TODO create module listenable
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

          # Add person to room
          add listed
          write_to_stream s.approve!

          # Welcome message
          reply = Blather::Message.new s.from
          reply.body = "Obrigado por vender a sua alma."
          reply.xhtml = "Obrigado por vender a sua <b>alma</b>."
          write_to_stream reply
        else
          logger.debug "ignored chat request from #{s.from}"
          reply = Blather::Message.new s.from
          reply.body = "Você não está na lista de pessoas vip."
          reply.xhtml = "Você não está na lista de pessoas vip."
          write_to_stream reply
        end
      end

      Ariera.subscription :subscribed? do |s|
        unless in_room? s.from
          listed = Person.where(:identity => s.from).first

          add listed

          reply = Blather::Message.new s.from
          reply.body = "Obrigado por vender a sua alma."
          reply.xhtml = "Obrigado por vender a sua <b>alma</b>."
          write_to_stream reply
        else
          logger.debug "already subscribed from #{s.from}"
        end
      end
    end

    def initialize_people
      @people = {}

      @room.people.each do |person|
        @people[person.identity] = person.name

        if person.identity?

          # Update nickname of people
          item = roster[person.identity]

          logger.warn "Roster not found for identity #{person.identity}, does the chat room have this contacts added?" unless item

          if item and item.name != person.nickname
            item.name = person.nickname
            roster.push item
          end

        else
          logger.warn "Identity not found for person #{person.inspect}"
        end
      end
    end
  end
end
