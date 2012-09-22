# -*- coding: utf-8 -*-
module Commands
  class Ponctuate
    include Command::Commandable

    guard 'pontuar .+'
    parameter :person
    parameter :reason

    help :syntax => 'pontuar <pessoa> <motivo...>', :description => 'Adiciona 1 ponto para <pessoa> por ter feito <motivo>.'

    handle do |m, params|
      r = m.reply

      puts params.inspect

      voter = Person.where(:identity => Blather::JID.new(m.from).stripped).first
      person = Person.named(params[:person][:name].downcase).first unless params[:person].nil?

      if params[:reason]
        params[:reason][:name] += params[:reason][:modifier] unless params[:reason][:modifier].blank?
        reason = params[:reason][:name]
      end

      if voter
        if person
          if reason
            point = Point.new
            point.reason = reason
            point.amount = 1
            point.person = voter

            person.points << point

            person.score ||= 0 # TODO callback on adicionar entidade para setar valores padrao
            person.score += 1

            if person.save
              r.body = "Woohoo\! #{person.name.capitalize} agora com #{person.score} pontos, por #{point.reason}"
            else
              r.body = 'Erro ao pontuar pessoa.'
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
end

Commands::Ponctuate.new
