message :chat?, 
[:body => /(\[[^\]]*\])? ajuda/, :body => /(\[[^\]]*\])? i need somebody,? help!?/i] do |m|
  puts 'executing: ajuda'
  r = m.reply

  comandos = "\n"
  comandos += "Comandos: \n"
  comandos += "pontuar <pessoa> <motivo> \n"
  comandos += "<termo>+1 ou <termo>-1\n"
  
  r.body = comandos
  write_to_stream r
end
