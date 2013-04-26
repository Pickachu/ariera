module Ariera
  class Room
    class Message
      attr_writer :sender
      attr_accessor :stanza, :original_sender, :room, :pseudonym
      delegate :to, :to=, :from, :from=, :body, :body=, :to => :stanza

      delegate :my_roster, :write_to_stream, :logger, :to => Ariera
      alias_method :roster, :my_roster

      def initialize room, raw
        @room = room

        # The broadcast message must be from the bot
        @stanza = Blather::Stanza::Message.new
        @stanza.from = room.identity

        @original_sender = Blather::JID.new(raw.from)           # Original sender to the bot

        # Try sender from roster
        # TODO move sender to Room::Participant
        @sender = sender_for(@original_sender)
        @pseudonym = person_for(@sender).name

        stanza.body = Sanitize.clean(raw.body)                  # Original body


        self.formatted_body = raw.body                                    # Formatted body
        self.formatted_body = raw.xhtml unless raw.xhtml.blank?
      end

      def formatted_body
        stanza.xhtml
      end

      def formatted_body= body
        stanza.xhtml = body
      end

      def formatted?
        not stanza.xhtml.blank?
      end

      def broadcast
        logger.debug "#{reply.from}: #{reply.body}"
        sender_jid = sender

        # TODO implement resource priority
        room.roster.each do |item|
          receiver_jid = Blather::JID.new item.jid

          # Do not broadcast to people outside room, TODO filter people by room
          next unless room.in_room? receiver_jid

          # Do not broadcast to self
          next if (sender_jid  == receiver_jid.stripped)
          next unless item.jid.to_s.include? '@'              # TODO Discover why some jids are coming as pseudonyns

          stanza.to = receiver_jid
          deliver
        end
      end

      def sender stripped = true
        @sender.stripped
      end

      def reply
        stanza.to = sender
        self
      end

      def deliver
        write_to_stream stanza
      end

      private
      # TODO Move this to participant
      def person_for sender
        room.people[sender.stripped.to_s] || Person.new(identity: sender)
      end

      def sender_for identity
        stripped = identity.stripped.to_s
        item = roster[stripped]

        if item
          sender = item.jid
        else
          # When sender already leaved the room we must retrieve it from people
          person = room.people[stripped]

          if person
            # TODO Move this to Room::Subscription
            Blather::JID.new person.identity
          else
            # If we can't find a sender in the room
            # just use the original message sender
            Blather::JID.new identity
          end
        end
      end
    end
  end
end
