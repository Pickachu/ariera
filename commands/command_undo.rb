# -*- coding: utf-8 -*-
message :chat?, :body => /^(\[[^\\]+\] )?desfazer .+/i do |m|
  puts 'executing desfazer'
  r = m.reply
  params = m.body.gsub(/^\[[^\\]+\] /, '').scan /"[^"]*"|'[^']*'|[^"'\s]+/
  name = m.body.scan(/^\[([^\\]+)\]/)

  person = Person.find_by_name(name.flatten.first.downcase)
  
  if person
    case params[1]
    when 'voto'
      vote = Vote.recent.find_by_person_id(person.id)
      
      if vote
        if vote.destroy
          r.body = "Voto para #{vote.votable.name} desfeito."
        else
          r.body = ''
          
          vote.errors.full_messages.each do |message|
            r.body += "#{message}\n"
          end
        end
      else
        r.body = "Nenhum voto efetuado por #{person.name.capitalize}."
      end
    else
      r.body = "Entindade inexistente para adicionar: #{params[1]}."
    end
  else
    r.body = 'Pessoa não encontrada para desfazer ação: ' + name + '.'
  end

  write_to_stream r
end
