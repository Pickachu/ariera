# encoding: utf-8
module Ariera
  class Room
    class Branch
      include ::Command::Commandable
      delegate :room, :to => Ariera

      guards ['branch.*', 'galho.*', 'fork.*', 'caminho.*', 'branches', 'galhos', 'caminhos', 'forks']
      help :syntax => 'branch [nome]', :variants => [:galho, :caminhos, :forks], :description => 'Muda ou lista assuntos das conversas'
      parameter :name

      after_initialize :add_branch_to_room
      after_receive :store_message

      # TODO Fazer formato html
      # TODO add support for subcommands
      handle do |message, params|
        reply = message.reply

        name = params[:name]
        if name.present?
          branch = ::Branch.find_or_initialize_by name: name[:name]
          new_branch = branch.new_record?

          # Trocar de branch
          if branch.save!
            room.current_branch = branch
            body = "Estamos agora no branch #{branch.name}!"
            body += "(criado agora)" if new_branch
          end
        else
          # Listar branchs
          current = room.record.current_branch
          branch_names = room.record.branches.map &:name
          branch_names = branch_names.each {|branch_name| branch_name = "=> #{branch_name}" if branch_name == current.name }
          body = "Branches Existentes: \n"
          body += branch_names.join "\n"
        end

        reply.body = body
        reply
      end

      subcommand :merge, %w{fechar close} do |message, params|
        branch = room.current_branch
        if branch.parent_branch.present?
          branch.merge!
          branch.save!
        end

        room.current_branch = branch.parent_branch
        room.save!

        "Merged #{branch.name} with #{branch.parent_branch.name}."
      end

      def add_branch_to_room

        room.class_eval do
          def current_branch
            @current_branch ||= record.current_branch
          end

          def current_branch= branch
            @current_branch = branch
          end

          def format_message stanza
            stanza.body = "[(#{current_branch.name}) #{stanza.pseudonym}] #{stanza.body}"
            stanza.formatted_body = "<span style=\"color: #666666;\"><b>#{stanza.pseudonym}</b></span>: #{stanza.formatted_body}" # Prefix with sender name
          end

        end

        unless room.current_branch.present?
          unless room.record.create_current_branch :name => :master
            raise "Unable to create default branch for room (#{room})!"
          end
        end
      end

      def store_message
        room.current_branch.messages.create :content => @message.xhtml || @message.body
      end
    end
  end
end

# TODO Change to Ariera::Room::Commands::Branch.new
Ariera::Room::Branch.new
