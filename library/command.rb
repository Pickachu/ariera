module Command
  module Commandable
    PREFIX = '^(?:\[[^\]]+\] )?'
    MEMBER = /'(?<name>[^\']*)'\s?|"(?<name>[^\"]*)"\s?|(?<name>[a-z]+)?(?<modifier>[^\s]*)\s?/i

    # Command class modificationsguards
    attr_accessor :tries
    delegate :message, :write_to_stream, :my_roster, :logger, :to => Ariera # Move to module client dsl

    alias_method :roster, :my_roster

    # TODO remove Ariera methods from this module
    def guarded?
      self.class.guards.any?
    end
    
    def initialize
      @guards = self.class.guards
      @parameters = self.class.parameters
      @parameters ||= []
      @parameters.unshift :command # First parameter is aways the command name
      listen
    end
    
    def listen
      return false unless guarded?
      throw "Handler not defined for command" if self.class.handler.nil?
      
      # Make regexps to match message
      
      # TODO Implement before filter
      message :chat?, normalized_guards do |message|
        # Store command namey
        command_name = self.class.to_s
        logger.info "#{message.from}##{command_name}: #{message.body}"

        

        params = normalize_parameters(parse_parameters(message.body))
        
        begin
          logger.info "#{command_name} executing"
          
          r = self.instance_exec(message, params, &self.class.handler)
          
          unless r.nil?                     
            write_to_stream r 

            # Broadcasta command result to other people
            if Ariera.configuration[:mode] === :room
              message.body = r.body || r
              Ariera.room.receive(Ariera::Room::Command.new(Ariera.room, message))
            end
          end
        rescue Exception => e
          r = message.reply
          r.body = 'Youbaa!! ' + e.message.capitalize
          write_to_stream r
          
          # TODO colorir o console
          logger.error "Command::#{command_name}" + "\n" + e.message + "\n"
          puts e.backtrace
        end
        
        # Mark as a command handled
        Commandable.handled = true
      end            
      
      # Show some routes information
      Ariera.logger.debug 'Command: listening to ' + normalized_guards.inspect
    end
    
    private
    
    def parse_parameters(body) 
      unnamed = []
      tries = 100
      until body.empty? || tries == 0
        match = MEMBER.match body
        unnamed << match
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
        params[@parameters.last].names.each do |name|
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
    
    def normalized_guards
      guards = []
      @guards.each do |regexp|
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
      attr_accessor :parameters, :handler, :help
      
      def in_room
        include Command::Room
      end

      def guard(guard)
        @guards ||= []
        @guards.push guard
      end
                                  
      def guards(guards = nil)
        @guards ||= []
        @guards = guards unless guards.nil?      
        @guards
      end 
      
      def parameter(name, *args)
        @parameters ||= []
        @parameters.push(name)
      end
      
      def help hash
        @help = hash
      end

      def handle &block
        @handler = block
      end          
    end
  end
end
