# -*- coding: utf-8 -*-
class Commands::Cowboy
  include Command::Commandable

  guard 'cowboy'

  handle do |m, params|
    # @todo Encapsular na classe command daqui
    puts 'executing cowboy'

    r = m.reply
    person = Person.named(params[:name].downcase).first
    
    unless person.nil?
      unless person.cowboy.nil?
        r.body = "Se estivéssemos no sunset riders, seu nome seria: " + person.cowboy.name + "."
      else
        r.body = "Uma pena mas você não tem nome de cowboy ainda #{person.name}"
      end
    else
      r.body = "Pessoa não encontrada para busca de nome cowboy: #{params[:name]}"
    end
    
    r
  end
end

# TODO Instantiate classes out of here
Commands::Cowboy.new
