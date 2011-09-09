require 'initialize.rb'

def purify string
  return string.gsub(/\[[^\]]*\] /, '')
end


setup 'heitor.salazar@izap.com.br', '74193456', 'talk.google.com'

when_ready do
  puts 'Connected'
end


#before(:message) do |m|
#  m.body.gsub!(/\[[^\]]*\] /, '')
#end

# Inclui comandos
Dir["commands/*.rb"].each {|file| require file}

disconnected do 
  puts 'Disconnected'
end
