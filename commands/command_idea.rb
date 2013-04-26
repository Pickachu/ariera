# -*- coding: utf-8 -*-
module Commands
  class Idea
    include Command::Commandable

    guards ['idea .+', 'pensei em .+', 'id[ée]ia .+']
    parameter :idea

    help :syntax => 'idea <sua ideia>', :variants => [:add, :adicionar], :description => 'Adiciona uma nova idea de comando para o bot'

    handle do |m, params|
      idea = params[:idea][:name]

      unless idea.blank?
        File.open(File.join(File.dirname(__FILE__), '..', 'ideas.txt'), 'a+') do |file|
          file.puts idea
        end

        "Idéia de comando adicionada!"
      end
    end
  end
end

# TODO Instantiate classes out of here
Commands::Idea.new
