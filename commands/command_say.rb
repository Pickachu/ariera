# -*- coding: utf-8 -*-
module Commands
  class Say
  include Command::Commandable

  guards ['say .+', 'speak .+', 'diga .+', 'fale .+']
  parameter :message

  handle do |m, params|
    r = m.reply

    if params[:message]
      full_message = params[:message][:name]
      full_message = params[:message][:modifier] unless params[:message][:modifier].blank?
      %x[say '#{full_message}']
    else
      r.body = "Texto não informado para pronunciar"
    end

    r
  end
end
end

# TODO Instantiate classes out of here
Commands::Say.new
