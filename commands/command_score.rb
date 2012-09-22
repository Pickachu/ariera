# -*- coding: utf-8 -*-
module Commands
  class Score
    include Command::Commandable

    guards ['placar (de\s)?.+', 'pontos (de\s)?.+']
    parameter :person

    help :syntax => 'placar <pessoa>', :variants => [:'placar de', :'pontos de', 'pontos'], :description => 'Informações interessantes sobre placar da <pessoa>'

    handle do |m, params|
      # TODO include points
      person = Person.named(params[:person][:name].downcase).first unless params[:person].nil?

      if params[:person]
        if person
          points = person.points
          point = points.first

          # TODO implement render and response methods
          body = "Placar de #{person.name.capitalize} [Σ:#{points.count}]\n"
          body += "Último por: #{point.reason}. (#{point.created_at})\n"

          if points.count >= 2
            body += "Outros:\n"
            2.times do
              point = person.points[rand(person.points.count)]
              body += "Por: #{point.reason.capitalize} (#{point.created_at})\n"
            end
          end
          r = m.reply
          r.body = body
          r.xhtml = body.gsub "\n", "<br />"
          r
        else
          "Pessoa não encontrada: #{params[:person][:name]}. \n Para ver todas pessoas digite: participantes"
        end
      else
        # TODO implement syntax_error method
        'Pessoa não informada.'
      end
    end
  end
end

# TODO Instantiate classes out of here
Commands::Score.new

