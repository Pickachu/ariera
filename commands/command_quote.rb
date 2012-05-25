# -*- coding: utf-8 -*-
class Commands::Quote
  include Command::Commandable

  guards ['cita[cç][ãa]o .+', 'quote .+']
  parameter :type
  parameter :entity
  
  handle do |m, params|
    r = m.reply
    r.body = "Comando citação ainda não implementado"
    r
  end
end

# TODO Instantiate classes out of here
Commands::Quote.new
