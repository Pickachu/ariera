# -*- coding: utf-8 -*-
class CommandCowboy
  include Command

  def initialize
    @guards = ['cowboy']
    listen
  end

  def execute m, params
    # @todo Encapsular na classe command daqui
    puts 'executing cowboy'

    r = m.reply
    person = Person.find_by_name(params[:name].downcase)
    
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
CommandCowboy.new
