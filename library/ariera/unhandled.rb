class Ariera::Unhandled
  def initialize
    Ariera.logger.debug('unhandled') {'handling unhandled messages'}

    Ariera.message :chat?, :body do |m|
      unless Command.handled?
        Unhandled.create :message => m.body, :from => m.from 
        Ariera.logger.debug('unhandled') { "storing unhandled from #{m.from}"}
      else 
        Command.handled = false
      end             
    end    
  end
end
