# -*- coding: utf-8 -*-
class CommandFail
  include Command

  def initialize
    @guards = ['fail .+']
    @parameters = [:person, :reason]

    listen
  end

  def execute m, params
    puts 'executing: fail'
    
    r = m.reply
    voter = Person.find_by_name(params[:name].downcase)
    person = Person.find_by_name(params[:person][:name].downcase) unless params[:person].nil?
    
    if person && voter
      if params[:reason]
        point = Point.new
        point.reason = params[:reason][:name]
        point.amount = -1		  

        person.points << point
        person.score -= 1		  
        
        if person.save
          r.body = "Safadinho! #{person.name.capitalize} agora com #{person.score} pontos, por #{point.reason}"
        else
          r.body = 'Erro ao pontuar pessoa'
        end
      else
        r.body = 'Motivo da pontuação não informado.'
      end
    else
      if voter
        r.body = 'Pessoa não encontrada: ' + params[:person]
      else
        r.body = 'Votador inválido: ' + params[:name]
      end
    end
    
    r
  end
end

# TODO Instantiate classes out of here
CommandFail.new
