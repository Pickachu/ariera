# -*- coding: utf-8 -*-
module Commands
  class Soda
    include Command::Commandable

    guards ['soda*+', 'refrigerante*+']
    
    handle do |message, params|
      reply = message.reply
      table = []

      people.each do |person|
        table << [person.sodas, person.nickname]
      end

      puts table.inspect
      
      table.sort_by! { |line| line[0] }
      
      # if table.empty?
      #   next 'Nenhuma compra de refri computada para esta sala'
      # end 
      
      response = "Quem paga o refri é #{table[0].last}<br />"
      response += "Ultimos refris:"

      amount = []
      [5, table.length].min.times do 
        response += "<br />" + table.shift.join(' - ')
      end

      response
    end

    def people
      if Ariera.room
        Ariera.room.people.values
      else
        Person.all
      end
    end 
  end
end

# TODO Automatic instatiation of commands
Commands::Soda.new
