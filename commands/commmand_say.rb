Ariera.message :chat?, [
                 {:body => /^(\[[^\\]+\] )?say.*/i},
                 {:body => /^(\[[^\\]+\] )?speak.*/i},
                 {:body => /^(\[[^\\]+\] )?diga.*/i},
                 {:body => /^(\[[^\\]+\] )?fale.*/i}
                ] do |m|
  params = m.body.gsub(/^\[[^\\]+\] /, '').scan /"[^"]*"|'[^']*'|[^"'\s]+/
  
  params.shift
  speak = params.join(' ')

  system("say '#{speak}'")
end 
