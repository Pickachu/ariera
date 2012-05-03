# -*- coding: utf-8 -*-
class CommandPonctuate
  include Command

  def initialize
    @guards = ['pontuar .+']
    @parameters = [:person, :reason]

    listen
  end

  def execute m, params
    r = m.reply
    voter = Person.find_by_name(params[:name].downcase)
    person = Person.find_by_name(params[:person][:name].downcase) unless params[:person].nil?
    reason = params[:reason][:name]  unless params[:reason].nil?

    if voter
      if person
        if reason
          point = Point.new
          point.reason = reason
          point.amount = 1
          point.person = voter
          
          person.points << point
          person.score += 1		  
          
          if person.save
            r.body = "Woohoo\! #{person.name.capitalize} agora com #{person.score} pontos, por #{point.reason}"
          else
            r.body = 'Erro ao pontuar pessoa'
          end
        else
          r.body = 'Motivo da pontuação não informado.'
        end
      else
        r.body = 'Pessoa não encontrada: ' + params[:person][:name]
      end
    else
      r.body = 'Votador inválido: ' + params[:name]
    end
    
    r
  end
end

CommandPonctuate.new
