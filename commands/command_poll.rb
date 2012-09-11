# -*- coding: utf-8 -*-
class Commands::Poll
  include Command::Commandable

  guards ['enquete *+', 'poll *+']
  parameter :poll

  handle do |m, params|
    r = m.reply

    unless params[:poll].blank?
      params[:poll][:name] ||= ''
      params[:poll][:name] += params[:poll][:modifier] unless params[:poll][:modifier].blank?
    end

    poll = Poll.new params[:poll]

    unless poll.name.nil?

      if Poll.frank.exists?
        r.body = 'Ainda existem enquetes abertas. Enquetes não podem ser abertas.'
        next r
      elsif subcommand? poll.name
        r.body = 'Enviar subcomandos para enquete ainda não implementado.'
        # next send(poll.name.to_sym, m, params)
        next r
      end


      # If a poll with this name exists, show results of last poll
      poll.person = Person.identified_by(Blather::JID.new(m.from).stripped).first
      poll.state = :active

      if poll.save
        activate_subcommands :yes, :no
        r.body = "Enquete aberta. Votação pode ser iniciada."

        next r
      else
        r.body = 'Erro ao salvar enquete: '
        r.body += poll.errors.full_messages.join('\n')
        next r
      end
    end

    # Ver enquete atual
    poll = Poll.frank.first
    unless poll.nil?
      r.body = results poll
    else
      r.body = 'Nenhuma enquete em aberto.'
    end

    r
  end

  subcommand :close, %w{fechar close} do |message, params|
    r = message.reply
    poll = Poll.frank.first

    if poll
      creator = Person.identified_by(Blather::JID.new(message.from).stripped).first

      if poll.person_id == creator.id
        poll.state = :closed

        if poll.save
          deactivate_subcommands :yes, :no, :close
          r.body = "Resultados "
          r.body += results poll
        else
          r.body = "Erro ao fechar enquete"
        end
      else
        r.body = "Você não é dono desta enquete, somente #{creator.name} pode fecha-la."
      end
    else
      r.body = "Nenhuma enquete aberta no momento"
    end

    r
  end

  subcommand :yes, %w{sim yes} do |message, params|
    reply = message.reply

    poll = Poll.frank.first
    person = Person.identified_by(Blather::JID.new(message.from).stripped).first

    unless person.nil?
      unless poll.votes.by(person).exists?
        poll.votes << person.votes.create(:kind => :yes, :person => person)
        reply.body = "#{poll.name}? \n #{person.name.capitalize} diz que sim!"
        reply.xhtml = "<b>#{poll.name}</b>? <br /> #{person.name.capitalize} diz que sim!"
      else
        reply.body = "Você ja votou nessa enquete não é #{person.name}, safadinho?"
        reply.xhtml = "Você ja votou nessa enquete não é #{person.name}, safadinho?"
      end
    else
      reply.body = "Pessoa não encontrada para efetuar voto #{message.from}."
    end

    reply
  end

  subcommand :no, %w{no n[ãa]o} do |message, params|
    reply = message.reply

    poll = Poll.frank.first
    person = Person.identified_by(Blather::JID.new(message.from).stripped).first

    unless person.nil?
      # Prohibit multiple votes
      unless poll.votes.by(person).exists?
        poll.votes << person.votes.create(:kind => :no, :person => person)
        reply.body = "#{poll.name}? #{person.name.capitalize} diz que não!"
      else
        reply.body = "Você ja votou nessa enquete não é #{person.name}, safadinho?"
      end
    else
      reply.body = "Pessoa não encontrada para efetuar voto #{message.from}."
    end

    reply
  end

  def results poll
    text = "== \n"
    text += poll.name + "\n\n<br />"

    names = {:yes => [], :no => []}
    poll.votes.each do |vote|
      if (vote.kind == 'yes')
        names[:yes] << vote.person.name
      elsif (vote.kind == 'no')
        names[:no] << vote.person.name
      end
    end

    text += "\n<br />Sim (#{names[:yes].length}). #{names[:yes].join(', ')}\n"
    text += "\n<br />Não (#{names[:no].length}). #{names[:no].join(', ')}"
  end
end

# TODO Instantiate classes out of here
Commands::Poll.new
