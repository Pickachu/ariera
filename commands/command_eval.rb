# -*- coding: utf-8 -*-
module Commands
  class Eval
    include Command::Commandable

    help :syntax => 'eval <código>', :description => 'Executa código ruby no cliente.'
    guard 'eval .+'
    parameter :code

    handle do |message, params|
      reply = message.reply
      permited = ['heitor.salazar@izap.com.br', 'heitorsalazar@gmail.com']
      
      identity = Blather::JID.new(message.from).stripped
      # sender = Person.where(:identity => identity).first

      next "Você não tem permissão pra fazer esse tipo de coisa né?" unless permited.include? identity

      reply.body = eval(params[:code].values.join(''))
      reply
    end
  end
end

# TODO Automatic instatiation of commands
Commands::Eval.new
