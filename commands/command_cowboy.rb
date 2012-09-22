# -*- coding: utf-8 -*-
module Commands
  class Cowboy
    include Command::Commandable

    guard 'cowboy'

    parameter :person

    help :syntax => 'cowboy [nome]', :description => 'Exibe seu nome de cowboy, ou da pessoa de nome [nome]. \n (O nome de cowboy é ganhando através de grandes feitos) '

    handle do |m, params|
      # @todo Encapsular na classe command daqui

      r = m.reply
      if (params[:person])
        identifier = params[:person][:name]
        person = Person.named(identifier).first
      else
        identifier = Blather::JID.new(m.from).stripped
        person = Person.identified_by(identifier).first
      end

      unless person.nil?
        unless person.cowboy.nil?
          r.body = "Se estivéssemos no sunset riders, o nome de #{person.name} seria: " + person.cowboy.name + "."
        else
          r.body = "Uma pena mas você não tem nome de cowboy ainda #{identifier}."
        end
      else
        r.body = "Pessoa não encontrada para busca de nome cowboy: #{identifier}."
      end

      r
    end
  end
end

# TODO Instantiate classes out of here
Commands::Cowboy.new
