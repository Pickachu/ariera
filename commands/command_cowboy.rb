# -*- coding: utf-8 -*-
class Commands::Cowboy
  include Command::Commandable

  guard 'cowboy'

  parameter :person

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

# TODO Instantiate classes out of here
Commands::Cowboy.new
