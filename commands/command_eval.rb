# -*- coding: utf-8 -*-
require 'cgi'

module Commands
  class Eval
    include Command::Commandable

    help :syntax => 'eval <código>', :description => 'Executa código ruby no cliente.'
    guard 'eval .+'
    parameter :code

    handle do |message, params|
      reply = message.reply
      permited = ['heitor.salazar@izap.com.br', 'heitorsalazar@gmail.com', 'luccamordente@gmail.com']

      identity = Blather::JID.new(message.from).stripped.to_s
      # sender = Person.where(:identity => identity).first

      next "Você #{identity} não tem permissão pra fazer esse tipo de coisa né?" unless permited.include? identity

      begin
        reply.body = CGI.escapeHTML eval(params[:code].values.join('')).inspect
      rescue Exception => e
        reply.body = CGI.escapeHTML e.message
      end

      reply
    end
  end
end

# TODO Automatic instatiation of commands
Commands::Eval.new
