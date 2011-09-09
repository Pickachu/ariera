# -*- coding: utf-8 -*-
message :chat?, 
[:body => /^(\[[^\\]+\] )?almoço .+/i, 
 :body => /^(\[[^\\]+\] )?bora n[ao] .+/i,
 :body => /^(\[[^\\]+\] )?quero ir .+/i] do |m|
  puts 'executing: lunch'
  params = m.body.gsub(/^\[[^\\]+\] /, '').scan /"[^"]*"|'[^']*'|[^"'\s]+/
  name = m.body.scan(/^(\[[^\\]+\])/)


  if (['quero', 'bora'].include? params[0]) params.shift

  r = m.reply
  person = Person.find_by_name(name)
  
  if person
    if params[2]
      food_establishment = FoodEstablishment.find_by_name(params[2])
      vote = Vote.new
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
    r.body = 'Pessoa não encontrada para efetuar voto: ' + name
  end

  write_to_stream r
end
