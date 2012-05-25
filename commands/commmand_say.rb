# -*- coding: utf-8 -*-
class Commands::Say
  include Command::Commandable

  guards = ['say .+', 'speak .+', 'diga .+', 'fale .+']
  parameter :message

  handle do |m, params|
    r = m.reply
    
    if params[:message]
      system("say '#{params[:message][:name]}'")    
    else
      r.body = "Texto não informado para pronunciar"
    end
    
    r
  end
end

# TODO Instantiate classes out of here
Commands::Say.new
