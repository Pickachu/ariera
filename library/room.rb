# encoding: utf-8
module Ariera
  class Room
    # Move to module Ariera::Client::DSL
    delegate :message, :write_to_stream, :my_roster, :logger, :shell, :to => Ariera
    alias_method :roster, :my_roster

    delegate :identity, :to => :room

    # TODO Rename :room to :record
    attr_accessor :room, :people
    alias_method :record, :room
    alias_method :record=, :room=

    def initialize identity
      logger.debug "initialzing room #{identity}"
      @room = ::Room.find_or_create_by :identity => identity.stripped

      initialize_people
      listen
      autoaprove
    end

    def receive stanza
      if in_room? stanza.sender

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
        listed = Person.where(:identity => s.from.stripped).first

        if (listed)
          logger.debug "approved subscription request from #{s.from}"

          # Add person to room
          add listed
          write_to_stream s.approve!

          # Welcome message
          reply = ::Blather::Stanza::Message.new s.from
          reply.body = "Obrigado por vender a sua alma."
          reply.xhtml = "Obrigado por vender a sua <b>alma</b>."
          write_to_stream reply
        else
          logger.debug "ignored chat request from #{s.from}"
          reply = ::Blather::Stanza::Message.new s.from
          reply.body = "Você não está na lista de pessoas vip."
          reply.xhtml = "Você não está na lista de pessoas vip."
          write_to_stream reply
        end
      end

      Ariera.subscription :subscribed? do |s|
        reply = ::Blather::Stanza::Message.new s.from
        reply.from = s.to

        unless in_room? s.from.stripped
          listed = Person.where(:identity => s.from.stripped).first

          add listed if listed

          reply.body = "Obrigado por vender a sua alma."
          reply.xhtml = "Obrigado por vender a sua <b>alma</b>."

          unless listed
            reply.body += "\n Antes entrar na sala você precisará definir seu apelido."
            reply.body += "\n Digite: apelido <meu apelido>"
            reply.xhtml += "<br />Antes entrar na sala você precisará definir seu apelido."
            reply.xhtml += "<br />Digite: apelido <u>meu apelido</u>"
          end

          write_to_stream reply
        else
          logger.debug "already subscribed from #{s.from}"

          reply.body = 'Não temos biscoitos aqui.'
          reply.xhtml = '<span style="color: #eec803;">Não temos biscoitos aqui.</span>'
          write_to_stream reply
        end
      end

      # Someone unsubscribed from the room
      Ariera.subscription :unsubscribed? do |s|
        reply = Blather::Stanza::Message.new
        reply.from = s.from
        reply.body = "Esse chat é muito cansativo pra mim. Serei um desertor."
        reply.xhtml = "Esse chat é muito cansativo pra mim. Serei um <b>desertor</b>."

        # TODO remove roster and remove person from room (remove participant)
        person = Person.where(:identity => s.from.stripped).first
        person.room = nil
        person.save

        receive Ariera::Room::Message.new(self, reply) if in_room? s.from.stripped
      end
    end

    def initialize_people
      @people = {}

      @room.people.each do |person|
        @people[person.identity] = person

        if person.identity?

          # Update nickname of people
          item = roster[person.identity]

          logger.warn "Roster not found for identity #{person.identity}, does the chat room have this contact added?" unless item

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
