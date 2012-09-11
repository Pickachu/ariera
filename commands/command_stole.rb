# -*- coding: utf-8 -*-
class Commands::Steal
  include Command::Commandable

  guard 'roubar .+'
  guard 'steal .+'

  parameter :thief
  parameter :victim
  parameter :reason
  
  help :syntax => 'roubar <ladrão> <vítma>', :variants => [:steal], :description => "Rouba 1 ponto de <vítma> e passa para <ladrão>"
                                                                       
  handle do |m, params|
    r = m.reply
    voter = Person.identified_by(Blather::JID.new(m.from).stripped).first
    thief = Person.named(params[:thief][:name].downcase).first unless params[:thief].nil?
    victim = Person.named(params[:victim][:name].downcase).first unless params[:victim].nil?

    if (voter.name == victim.name)
      r.body = 'Roubando pontos de si mesmo ein?? Dexa de ser idiota!'
      return r
    end

    if voter 
      if victim
        if thief
          if params[:reason]
            reason = params[:reason][:name]

            pointThief = Point.new
            pointThief.reason = "Roubando ponto de #{victim.name} por #{reason}."
            pointThief.amount = +1
            pointThief.person = voter

            pointVictim = Point.new
            pointVictim.reason = "Foi roubado de #{thief.name} por #{reason}."
            pointVictim.amount = -1
            pointVictim.person = voter

            thief.points << pointThief
            thief.score += 1

            victim.points << pointVictim
            victim.score -= 1

            if thief.save && victim.save
              r.body = "CHUPA! #{thief.name.capitalize}[#{thief.score}] roubou um ponto de #{victim.name.capitalize}[#{victim.score}] por #{reason}"
            else
              r.body = "Erro ao pontuar pessoa."
            end
          else
             r.body = 'Motivo do crime não informado.'
          end
        else
         r.body = "Ladrão não encontrado: " + params[:thief][:name]
        end
      else
        r.body = "Vítima não encontrada: " + params[:victim][:name]
      end
    else
     r.body = "Não levamos a opnião do " + params[:name] + " a sério nesse chat. Voto Inválido."
    end

   r
  end
end

Commands::Steal.new
