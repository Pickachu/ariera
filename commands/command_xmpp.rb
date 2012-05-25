# -*- coding: utf-8 -*-
class Commands::Xmpp
  include Command::Commandable

  attr_accessor :locations, :probed
  guard 'xmpp .+'
  
  parameter :command
  parameter :to

  def initialize
    super
    @locations = []
    @probed = false
  end

  # help {:syntax => 'adicionar <entidade> <nome>', :variants => [:add, :adicionar], :description => 'Adiciona entidade'}

  def probed?
    @probed
  end
    
  handle do |m, params|
    r = m.reply
    puts params.inspect
                
    case params[:command][:name]
    when 'roster'  
      jid = params[:to][:name] + params[:to][:modifier]
      item = roster[jid]
      response = ''
      if item 
        body = "Name: #{item.name}\n"
        body += "Jid: #{item.jid}\n"
        body += "Subscription: #{item.subscription}\n" 
        body += "Ask: #{item.ask}\n" 
                     
        item.groups.each do |group|
          body += "Group: #{group}\n"
        end

        item.statuses.each do |status|
          body += "Status: #{status}\n"
        end

        r.body = body
      end
    when 'probe'                                    
      presence = Blather::Stanza::Presence.new
      jid = params[:to][:name] + params[:to][:modifier]

      # TODO test for jid
      presence.type = :probe
      presence.to = jid

      # Listen for answer
      Ariera.presence :from => Regexp.new("^#{jid}") do |presence|
        unless probed?
          @probed = true
          r.body = "Type 'xmpp probed' to see results"
          Ariera.write_to_stream r                                        
        end

        locations << presence.from
      end

      Ariera.write_to_stream presence
      r.body = "probing..."
    when 'probed'
      r.body = 'Result: ' + locations.join(" - ")
      @locations = []
      Ariera.instance.clear_handlers :presence
    end     
    
    r
  end
end

# TODO Instantiate classes out of here
Commands::Xmpp.new
