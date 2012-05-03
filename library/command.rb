module Command
  attr_accessor :guards, :prefix, :parameters
  
  # TODO remove Ariera methods from this module

  def listen
    guards = []
    prefix = '^(?:\[[^\]]+\] )?'
    member = /'(?<name>[^\']*)'\s?|"(?<name>[^\"]*)"\s?|(?<name>[a-z]+)?(?<modifier>[^\s]*)\s?/i

    # Make regexps to match message
    @guards.each do |regexp|
      guards << {:body => Regexp.new(prefix + regexp, Regexp::IGNORECASE)}
    end

    # TODO Implement before filter
    # Parse intial message
    prepare = lambda do |m|
      puts "#{m.from}: #{m.body}"

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

        # Add unamed parameters to the last parameters
        if unamed_params.any?
          last = {:name => '', :modifier => ''}
          if params[@parameters.last]
            params[@parameters.last].names.each do |name|
              last[name.to_sym] = params[@parameters.last][name] unless params[@parameters.last][name].nil?
            end
          end
              
          unamed_params.each do |match|
            last[:name] += ' ' + match[:name].to_s unless match[:name].nil?
            last[:modifier] += ' ' + match[:modifier].to_s unless match[:modifier].nil?
          end

          last[:name].strip!
          last[:modifier].strip!

          params[@parameters.last] = last
        end
      end
      
      begin
        puts 'executing: ' + self.class.to_s
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


