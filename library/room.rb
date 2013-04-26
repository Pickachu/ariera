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
        reply.body = "Você não está na sala safadinho!"
        reply.formatted_body = "Você <b>não está na sala</b> safadinho!"
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
        receive Message.new(self, message)
      end
    end

    def add person
      @people[person.identity] = person
      @room.people << person
      @room.save
    end

    def autoaprove
      # Consolidate current roster list
      roster.each do |item|
        if item.subscription == :none
          reply = ::Blather::Stanza::Message.new item.jid
          reply.body = "Por algum motivo misterioso do universo\n você perdeu o contato com a sala, por favor aceite o convite."
          reply.xhtml = "Por algum motivo misterioso do universo\n você perdeu o contato com a sala, por favor aceite o convite."
#          write_to_stream reply

          invite = Blather::Stanza::Presence::Subscription.new
          invite.request!
          invite.from = identity
          invite.to = item.jid

          logger.debug "re-requested invite for #{item.jid}"

#          write_to_stream invite
        end
      end

      # Automatically accept existing people income requests
      Ariera.subscription :request? do |s|
        listed = Person.where(:identity => s.from.stripped).first

        if listed
          # Add person to room
          add listed

          # Accept invite
          write_to_stream s.approve!

          # Welcome message
          reply = ::Blather::Stanza::Message.new s.from
          reply.body = "Obrigado por vender a sua alma."
          reply.xhtml = "Obrigado por vender a sua <b>alma</b>."
          write_to_stream reply
        else
          reply = ::Blather::Stanza::Message.new s.from
          reply.body = "Você não está na lista de pessoas vip."
          reply.xhtml = "Você não está na lista de pessoas vip."
          write_to_stream reply
        end
      end

      # When people are invited and accepts the invitation
      # adds people to room
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
          reply.body  = 'Não temos biscoitos aqui.'
          reply.xhtml = '<span style="color: #eec803;">Não temos biscoitos aqui.</span>'
          write_to_stream reply
        end
      end

      # Someone unsubscribed from the room
      Ariera.subscription :unsubscribed? do |s|

        # TODO remove roster and remove person from room (remove participant)
        person = Person.where(:identity => s.from.stripped).first

        unless person
          reply = ::Blather::Stanza::Message.new s.from
          reply.from = s.to
          reply.body = "Não foi possivel encontrar a pessoa #{s.from} na sala."
          next
        end

        person.room = nil
        person.save

        reply = Blather::Stanza::Message.new
        reply.from = s.from
        reply.body = "Esse chat é muito cansativo pra mim. Serei um desertor."
        reply.xhtml = "Esse chat é muito cansativo pra mim. Serei um <b>desertor</b>."

        receive Ariera::Room::Message.new(self, reply)
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
