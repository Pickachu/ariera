# -*- coding: utf-8 -*-
module Commands
  class Lunch
    include Command::Commandable

    guards ['almo[çc]o.*', 'suggest .+', 'bora n[ao] .+', 'quero ir no .+'] 

    handle do |m|
      r = m.reply
      
      params = m.body.gsub(/^\[[^\\]+\] /, '').scan /"[^"]*"|'[^']*'|[^"'\s]+/
      
      person = Person.where(:identity => Blather::JID.new(m.from).stripped).first
      
      if person
        voted_today = person.choices.today.where(:votable_type => 'FoodEstablishment').count 
        
        if params[1]
          unless voted_today > 0
            food_establishment = FoodEstablishment.named(params[1]).first
            
            if food_establishment
              vote = Vote.new
              vote.person = person
              
              food_establishment.votes << vote
              
              if food_establishment.save
                r.body = "Voto por #{person.name.capitalize} para almoçarmos no #{food_establishment.name}, agora com #{food_establishment.votes.count} votos, hoje: #{food_establishment.votes.today.count}." 
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
        unless person.nil?
          r.body = 'Pessoa não encontrada para efetuar voto: ' + person.name.to_s
        else
          r.body = "Pessoa não encontrada com a identidade #{m.from}."
        end
      end
      
      r
    end
  end
end

Commands::Lunch.new
