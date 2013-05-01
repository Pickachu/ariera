module Commands
  class Participant
    include Command::Commandable

    guards ['participants', 'participantes', 'na sala']
    help :syntax => 'participantes', :variants => [:participants, :'na sala'], :description => 'Lista pessoas na sala de chat'


    # TODO Fazer formato html
    handle do |message|
      reply = message.reply
      format = "[%s] => %s <%s> \n"
      body = "Participantes da sala \n"
      sender = Person.where(:identity => Blather::JID.new(message.from).stripped).first

      # TODO use room reference
      sender.room.people.each do |person|
        body += format(format, person.pseudonym, person.name, person.identity)
      end

      reply.body = body
      reply.xhtml = body.gsub("\n", '<br />');
      reply
    end
  end
end

Commands::Participant.new
