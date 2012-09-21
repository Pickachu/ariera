module Commands
  class Domo
    include Command::Commandable

    guard 'domo'

    handle do |message, params|
      reply = message.reply
      reply.body = 'kun'
      reply
    end
  end
end

# TODO Automatic instatiation of commands
Commands::Domo.new
