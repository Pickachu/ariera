# -*- coding: utf-8 -*-
class CommandStole
  include Command

  def initialize
    @guards = ['roubar .+']
    @parameters = [:thief, :victim, :reason]

    listen
  end

  def execute m, params
    puts 'executing: roubar'
    
    r = m.reply
    voter = Person.find_by_name(params[:name].downcase)
    thief = Person.find_by_name(params[:thief][:name].downcase) unless params[:thief].nil?
    victim = Person.find_by_name(params[:victim][:name].downcase) unless params[:victim].nil?

    if voter 
      if victim
        if thief
          if params[:reason]
            pointThief = Point.new
            pointThief.reason = params[:reason][:name]
            pointThief.amount = +1
            pointThief.person = voter

            pointVictim = Point.new
            pointVictim.reason = params[:reason][:name]
            pointVictim.amount = -1
            pointVictim.person = voter

            thief.points << pointThief
            thief.score += 1

            victim.points << pointVictim
            victim.score -= 1

            if thief.save && victim.save
              r.body = "CHUPA! #{thief.name.capitalize}[#{thief.score}] roubou um ponto de #{victim.name.capitalize}[#{victim.score}] por #{pointThief.reason}"
            else
              r.body = "Erro ao pontuar pessoa."
            end
          else
             r.body = 'Motivo do crime não informado.'
          end
        else
         r.body = "Ladrão não encontrado."+ params[:thief][:name]
        end
      else
        r.body = "Vítima não encontrada."+ params[:victim][:name]
      end
    else
     r.body = "Não levamos a opnião do " + params[:name] + " a sério nesse chat. Voto Inválido."
    end

   r
  end
end

CommandStole.new
