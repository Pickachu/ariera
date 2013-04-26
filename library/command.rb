module Command
  module Commandable
    PREFIX = '^(?:\[[^\]]+\] )?'
    MEMBER = /'(?<name>[^\']*)'\s?|"(?<name>[^\"]*)"\s?|(?<name>[[:alpha:]]+)?(?<modifier>[^\s]*)\s?/i

    # Command class modificationsguards
    attr_accessor :tries
    delegate :message, :write_to_stream, :my_roster, :logger, :clear_handlers, :to => Ariera # Move to module client dsl

    alias_method :roster, :my_roster

    # TODO remove Ariera methods from this module
    def guarded?
      self.class.guards.any?
    end

    def initialize
      @guards = self.class.guards
      @subcommands = self.class.subcommands
      @subcommands ||= {}
      @parameters = self.class.parameters
      @parameters ||= []
      @parameters.unshift :command # First parameter is aways the command name
      activate_subcommands *@subcommands.keys
      listen self.class.handler
    end

    def listen guards = @guards, handler
      return false unless guarded?
      throw "Handler not defined for command" if self.class.handler.nil?

      # Make regexps to match message

      # TODO Implement before filter
      message :chat?, normalized_guards(guards) do |message|

        # Store message
        @message = message

        # Store command name
        command_name = self.class.to_s
        logger.info "#{message.from}##{command_name}: #{message.body}"

        puts parse_parameters(message.body).inspect

        params = normalize_parameters(parse_parameters(message.body))

        begin
          logger.info "#{command_name} executing"

          # Execute handler for this message
          output = self.instance_exec(message, params, &handler)

          unless output.nil?
            # If output is a string just respond with it
            if output.kind_of? String
              reply = message.reply
              reply.body = output
            # If output is a message use it
            elsif output.kind_of? Blather::Stanza::Message
              reply = output.clone
            end

            # Default formatted message to body
            reply.xhtml = reply.body if reply.xhtml.blank?

            # In case of output come with formmatation, create default unformatted message
            reply.body = Sanitize.clean reply.body

            # TODO see if is to send message back to the user
            write_to_stream reply

            # Broadcast command result and user message to other people
            if Ariera.configuration[:mode] === :room

              # Broadcast user message
              Ariera.room.receive Ariera::Room::Message.new(Ariera.room, message)

              # Switch body to broadcast Command
              message.body = reply.body
              Ariera.room.receive(Ariera::Room::Command.new(Ariera.room, message, output))
            end
          end
        rescue Exception => e
          r = message.reply
          r.body = 'Youbaa!! ' + e.message.capitalize
          r.xhtml = '<span style="color: #df0c0a">Youbaa!! ' + e.message.capitalize + '</span>'
          write_to_stream r

          # TODO colorir o console
          logger.error "Command::#{command_name}" + "\n" + e.message + "\n"
          puts e.backtrace
        end

        # Mark as a command handled
        Commandable.handled = true
      end

      # Show some routes information
      logger.debug 'Command: listening to ' + normalized_guards(guards).inspect
    end

    def guard *arguments, &block
      message :chat?, normalized_guards(arguments), &block
    end

    def forsake *arguments
      clear_handlers :message, normalized_guards(arguments)
    end

    # Subcommand and contextual guarding management

    def activate_subcommands *subcommands
      subcommands.each do |name|
        subcommand = @subcommands[name]
        listen subcommand[:guards], subcommand[:handler]
        logger.debug 'Subcommand: listening to ' + normalized_guards(subcommand[:guards]).inspect
      end
    end

    def deactivate_subcommands *subcommands
      subcommands.each do |name|
        subcommand = @subcommands[name]
        clear_handlers :message, normalized_guards(subcommand[:guards])
      end
    end

    def subcommand? name
      @subcommands.keys.include? name.to_sym
    end

    # Person utility
    def sender
      @sender ||= Person.identified_by(Blather::JID.new(@message.from).stripped).first
    end

    private

    # Parsing
    def parse_parameters(body)
      unnamed = []
      tries = 100
      until body.empty? || tries == 0
        match = MEMBER.match body

        parameter = {}
        names = match.names
        captures = match.captures.compact

        puts captures.inspect
        puts names.inspect

        # TODO FIX for when only modifier provided
        captures.unshift('') if (captures.length == names.length - 1)

        raise 'Failed to parse command!' if captures.length != names.length

        captures.each do |capture|
          parameter[names.shift.to_sym] = capture
        end

        unnamed << parameter
        body = match.post_match.lstrip
        tries -= 1
      end
      throw 'Tentativas dimais ao parsear resposta!' unless tries > 0
      unnamed
    end

    def normalize_parameters matches
      params = {:unnamed => matches}
      @parameters.each do |name|
        params[name.to_sym] = params[:unnamed].shift
      end

      unnamed = params[:unnamed]

      # Add unamed parameters to the last parameters
      if unnamed.any?
        last = {:name => '', :modifier => ''}

      if params[@parameters.last]
        params[@parameters.last].keys.each do |name|
            last[name.to_sym] = params[@parameters.last][name] unless params[@parameters.last][name].nil?
          end
      end

        unnamed.each do |match|
          last[:name] += ' ' + match[:name].to_s unless match[:name].nil?
          last[:modifier] += ' ' + match[:modifier].to_s unless match[:modifier].nil?
        end

        last[:name].strip!
        last[:modifier].strip!

        params[@parameters.last] = last
      end

      params
    end

    def normalized_guards unmormalized = @guards
      guards = []
      unmormalized.each do |regexp|
        guards << {:body => Regexp.new(PREFIX + regexp, Regexp::IGNORECASE)}
      end
      guards
    end

    # Command module methods
    class << self
      attr_accessor :handled

      def handled?; handled; end;

      def included(base)
        base.extend(ClassMethods)
      end
    end

    # Command class methods to add
    module ClassMethods
      attr_accessor :parameters, :handler, :help, :subcommands

      def in_room
        include Command::Room
      end

      def guard(guard)
        @guards ||= []
        @guards << guard
      end

      def guards(guards = nil)
        @guards ||= []
        @guards = guards unless guards.nil?
        @guards
      end


      def parameter(name, *args)
        @parameters ||= []
        @parameters << name
      end

      def help hash = nil
        @help = hash if hash
        @help[:name] = self.name.split('::').last.downcase unless @help.has_key? :name
        @help
      end

      def docummented?
        not @help.nil?
      end

      def handle &handler
        @handler = handler
      end

      # Subcommand and contextual guarding management
      def subcommand name, guards, &handler
        @subcommands ||= {}
        @subcommands[name] = {:guards => guards, :handler => handler}
      end
    end
  end
end
