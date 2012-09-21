# -*- coding: utf-8 -*-
module Ariera
  class Room
    class Invite
      include ::Command::Commandable

      guards ['invite .+', 'invites .+', 'convidar .+', 'convide .+']
      parameter :identity

      handle do |message, params|
        reply = message.reply

        guest = params[:identity][:name]
        guest += params[:identity][:modifier] unless params[:identity][:modifier].blank?
        guest = Blather::JID.new guest
        guest.strip!

        inviter = Blather::JID.new reply.from

        invite guest, inviter.stripped

        reply.body = "Usuário #{guest} foi convidado."

        reply
      end

      def invite guest, inviter
        subscription = Blather::Stanza::Presence::Subscription.new
        subscription.request!
        subscription.from = inviter
        subscription.to = guest

        Ariera.write_to_stream subscription
      end
    end
  end
end

Ariera::Room::Invite.new
