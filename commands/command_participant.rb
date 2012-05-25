module Commands
  class Participant
    include Command::Commandable
   
    guards ['participants', 'participantes', 'na sala']

    handle do |message|
      reply = message.reply
      format = "[%s] => %s \n"
      body = "Participantes da sala \n"
      sender = Person.where(:identity => Blather::JID.new(message.from).stripped).first

      # TODO use room reference
      sender.room.people.each do |person|
        body += format(format, person.name, person.pseudonym, person.identity.gsub(/@.+/, ''))
      end       

      reply.body = body
      reply
    end 
  end    
end

Commands::Participant.new
