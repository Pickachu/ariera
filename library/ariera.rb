require 'blather/client/dsl'
module Ariera
  extend Blather::DSL

  setup 'heitor.salazar@izap.com.br', '74193456', 'talk.google.com'
  
  def self.run; client.run; end
    
  when_ready do
    puts 'Connected'
    
    # include commands
    Dir["commands/*.rb"].each {|file| require file}
  end
end
