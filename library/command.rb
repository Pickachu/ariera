module Command
  attr_accessor :guards, :prefix, :parameters
  
  # TODO remove Ariera methods from this module

  def listen
    guards = []
    prefix = '^(?:\[[^\]]+\] )?'
    member = /'(?<name>[^\']*)'\s?|"(?<name>[^\"]*)"\s?|(?<name>[a-z]+)?(?<modifier>[^\s]*)\s?/i

    # Make regexps to match message
    @guards.each do |regexp|
      guards << {:body => Regexp.new(prefix + regexp)}
    end

    # TODO Implement before filter
    # Parse intial message
    prepare = lambda do |m|
      puts 'prepared'
      params = {:name => m.body.scan(/^(?:\[([^\\]+)\] )?/).flatten.first }
      params[:name] = 'anonymous' if params[:name].nil?
      body = m.body.gsub Regexp.new(prefix), ''
            
      unamed_params = []
      tries = 100
      until body.empty? || tries == 0
        match = member.match body
        unamed_params << match
        body = match.post_match.lstrip
        tries -= 1
      end

      params[:command] = unamed_params.shift
      
      unless parameters.nil?
        @parameters.each do |name|
          params[name] = unamed_params.shift
        end
      end
      
      params[:unamed] = unamed_params unless unamed_params.nil? or unamed_params.empty?
      

      puts 'Parametros: ' + params.inspect

      begin
        r = self.execute m, params
        r.body = 'Tentativas dimais ao parsear resposta!' unless tries > 0
        write_to_stream r unless r.nil?
      rescue Exception => e
        r = m.reply
        r.body = 'Youbaa!! ' + e.message.capitalize
        write_to_stream r
        
        # TODO colorir o console
        puts "\n" + e.message + "\n"
        puts e.backtrace
      end
    end
    
    Ariera.message :chat?, guards, &prepare
  end

  def message *args, &block
    Ariera.message *args, &block
  end
  
  def write_to_stream *args, &block
    Ariera.write_to_stream *args, &block
  end
  
end


