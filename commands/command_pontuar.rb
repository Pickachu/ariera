# -*- coding: utf-8 -*-
message :chat?, :body => /^(\[[^\\]+\] )?pontuar .+/i do |m|
  puts 'executing: pontuar'

  r = m.reply
  params = m.body.gsub(/^\[[^\\]+\] /, '').scan /"[^"]*"|'[^']*'|[^"'\s]+/
  person = Person.find_by_name(params[1].downcase)
  
  if person
    if params[2]
      point = Point.new
      point.reason = params[2]
      point.amount = 1		  
      
      person.points << point
      person.score += 1		  
      
      if person.save
        r.body = "Woohoo\! #{person.name.capitalize} agora com #{person.score} pontos, porque #{point.reason}"
      else
        r.body = 'Erro ao pontuar pessoa'
      end
    else
      r.body = 'Motivo da pontuação não informado.'
    end
  else
    r.body = 'Pessoa não encontrada: ' + params[1]
  end

  write_to_stream r
end
