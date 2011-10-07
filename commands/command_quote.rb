# -*- coding: utf-8 -*-
class CommandQuote
  include Command

  def initialize
    @guards = ['cita[cç][ãa]o .+', 'quote .+']
    @parameters = [:type, :entity]
    listen
  end

  def execute m, params
    puts 'executing: quote'
    r = m.reply
    r.body = "Comando citação ainda não implementado"
    r
  end
end

# TODO Instantiate classes out of here
CommandQuote.new
