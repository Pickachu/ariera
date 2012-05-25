# -*- coding: utf-8 -*-
class Commands::Poll
  include Command::Commandable

  guards ['enquete *+', 'poll *+']
  parameter :poll

  handle do |m, params|
    puts 'executing: poll'
    r = m.reply
    
    poll = Poll.new params[:poll]
    
    unless poll.name.nil?
      if Poll.frank.count > 0
        r.body = 'Ainda existem enquetes abertas. Enquetes não podem ser abertas.'
        return r
      end
      
      poll.person = Person.find_by_name params[:name]
      
      if poll.save
        r.body = "Enquete aberta. Votação pode ser iniciada."
        return r
      end
    end

    # Ver enquete atual
    poll = Poll.frank
    unless poll.nil?
      r.body = results poll
    else
      r.body = 'Nenhuma enquete em aberto.'
    end
     
    r
  end

  def results poll
    text = '== \n'
    text += poll.name + "\n\n"
    
    names = {:yes => [], :no => []}
    poll.votes.each do |vote|
      if (vote.type == 'yes')
        names[:yes] << vote.person.name
      elsif (vote.type == 'no')
        names[:no] << vote.person.name
      end
    end
    
    text += "Sim (#{names[:yes].length}). #{names[:yes].join(', ')}\n" 
    text += "Não (#{names[:no].length}). #{names[:no].join(', ')}"
  end
end

# TODO Instantiate classes out of here
Commands::Poll.new
