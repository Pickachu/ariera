# -*- coding: utf-8 -*-
module Ariera
  class Room
    class Alias
      include ::Command::Commandable
      # TODO include automatically for commands in Room namespace ::Command::Room::Commandable

      delegate :my_roster, :write_to_stream, :to => Ariera
      alias_method :roster, :my_roster

      guards ['alias .+', 'nick .+', 'nickname .+', 'pseudonym .+', 'apelido .+', 'pseud[oô]nimo .+']
      parameter :pseudonym

      handle do |message, params|
        reply = message.reply

        # TODO create params[:pseudonym].to_s to return the full parameter
        guest = params[:pseudonym][:name]
        guest += params[:pseudonym][:modifier] unless params[:pseudonym][:modifier].blank?

        sender = Blather::JID.new reply.to
        reply.body = pseudonymize guest, sender.stripped.to_s

        reply
      end

      # Update name on contact list
      def rosterize pseudonym, identity
        item = roster[identity]
        item.name = pseudonym
        roster.push item
      end

      # TODO move to model
      def pseudonymize pseudonym, identity
        person = ::Person.any_of({:pseudonym => pseudonym}, {:name => pseudonym}, {:identity => identity}).first

        # Alguma pessoa foi encontrada com estes dados?
        if person
          if person.identity
            if person.identity == identity
              # TODO Look up for persons with same nickname on room
              person.pseudonym = pseudonym
              if person.save
                rosterize pseudonym, identity
                Ariera.room.add person
                "Você agora é conhecido como #{pseudonym}"
              else
                "Erro ao mudar seu apelido"
              end
            else
              "Bad identity: found #{person.identity}, expected #{identity}"
            end
          elsif pseudonym # apelido foi enviado, mas pessoa nao tem identidade, alterar apelido e identidade
            person.identity = identity
            person.pseudonym = pseudonym
            if person.save
              rosterize pseudonym, identity
              Ariera.room.add person
              "Você agora é conhecido como #{pseudonym}"
            else
              "Problema ao alterar seu nick"
            end
          else # apelido nao foi enviado, erro
            "Você precisa informar seu apelido, né?"
          end
        # Pessoa nao encontrada criar uma nova
        else
          person = ::Person.new :identity => identity, :pseudonym => pseudonym, :name => pseudonym

          if person.save
            rosterize pseudonym, identity
            Ariera.room.add person
            "Você agora é conhecido como #{pseudonym}"
          else
            "Problema ao definir o seu nick criando uma pessoa: #{person.errors.full_messages.join("\n")}"
          end
        end
      end
    end
  end
end

# TODO CHange to Ariera::Room::Commands::Alias.new
Ariera::Room::Alias.new
