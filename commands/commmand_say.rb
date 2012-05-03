# -*- coding: utf-8 -*-
class CommandSay
  include Command

  def initialize
    @guards = ['say .+', 'speak .+', 'diga .+', 'fale .+']
    @parameters = [:message]

    listen
  end

  def execute m, params
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
CommandSay.new
