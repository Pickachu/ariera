module Ariera
  class Room
    class Message
      attr_writer :sender
      attr_accessor :message, :original_sender, :room
      delegate :to, :to=, :from, :from=, :body, :body=, :to => :message

      delegate :my_roster, :write_to_stream, :logger, :to => Ariera
      alias_method :roster, :my_roster        
            
      def initialize room, raw        

        puts raw.from.inspect
        @room = room

        # The broadcast message must be from the bot
        @message = Blather::Stanza::Message.new room.identity

        @original_sender = Blather::JID.new(raw.from)           # Original sender to the bot
        @sender = roster[@original_sender.stripped.to_s].name

        message.body = raw.body                                         # Original body
      end
      
      # TODO remove write-to-stream from this function
      def broadcast
        logger.debug "#{reply.from}: #{reply.body}"
        sender_jid = sender
                     
        # TODO implement resource priority
        room.roster.each do |item|
          receiver_jid = Blather::JID.new item.jid

          # Do not broadcast to self
          next if (sender_jid  == receiver_jid.stripped)

          message.to = item.jid
          deliver
        end                      
      end
      
      def pseudonym
        @sender
      end

      def sender stripped = true
        if stripped
          original_sender.stripped
        else
          @sender
        end
      end  

      def reply
        message.to = sender
        self
      end  

      def deliver
        write_to_stream message
      end
    end   
  end
end
