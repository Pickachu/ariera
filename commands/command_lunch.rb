# -*- coding: utf-8 -*-
Ariera.message :chat?, [
                 {:body => /^(\[[^\\]+\] )?almo[çc]o.*/i}, 
                 {:body => /^(\[[^\\]+\] )?suggest .+/i}, 
                 {:body => /^(\[[^\\]+\] )?bora n[ao] .+/i}, 
                 {:body => /^(\[[^\\]+\] )?quero ir no .+/i}
                ] do |m| 

  # {:body => /^(\[[^\\]+\] )?almo[çc]o.*/i, :body => '[Heitor] almoco', , :body => /^(\[[^\\]+\] )?quero ir .+/i} do |m|

  puts 'executing: lunch'
  r = m.reply

  params = m.body.gsub(/^\[[^\\]+\] /, '').scan /"[^"]*"|'[^']*'|[^"'\s]+/
  name = m.body.scan(/^\[([^\\]+)\]/)

  person = Person.find_by_name(name.flatten.first.downcase)
  
  if person
    voted_today = person.choices.today.where(:votable_type => 'FoodEstablishment').count 
    
    if params[1]
      unless voted_today > 0
        food_establishment = FoodEstablishment.find_by_name(params[1])
        
        if food_establishment
          vote = Vote.new
          vote.person = person
          
          food_establishment.votes << vote
          
          if food_establishment.save
            r.body = "Voto por #{person.name.capitalize} para #{food_establishment.name}, agora com #{food_establishment.votes.count} votos, hoje: #{food_establishment.votes.today.count}." 
          else
            r.body = 'Erro ao salvar voto para almoco'
          end
        else
          r.body = 'Estabelecimento alimentício não encontrado: ' + params[1]
        end
      else
        r.body = "#{person.name.capitalize} você ja votou hoje né seu safadinho?"
      end
    elsif /almo[çc]o/ =~ params[0].downcase
      r.body = "\n\n== Almoço do dia \n"
      r.body += sprintf("%20s     %10s\n", 'Local', 'Votos')
      
      food_establishments = FoodEstablishment.joins(:votes).where(['votes.updated_at BETWEEN (?) AND (?)', Time.mktime(Time.now.year, Time.now.month, Time.now.day), Time.mktime(Time.now.year, Time.now.month, Time.now.day, 23, 59)] ).group('votes.votable_id')

      names = []
      food_establishments.each do |food_establishment|
        food_establishment.votes.today.each { |vote|  
          names << vote.person.name
        }
        r.body += sprintf("%20s     %10s %s\n", food_establishment.name.capitalize, food_establishment.votes.today.count, names.join(', '))
        names = []
      end
    end
  else
    unless name.nil?
      r.body = 'Pessoa não encontrada para efetuar voto: ' + name.to_s
    else
      r.body = 'Nome invalido de pessoa'
    end
  end

  Ariera.write_to_stream r
end
