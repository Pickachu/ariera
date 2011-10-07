Ariera.message :chat?, :body =>  /(\[[^\]]*\] )?domo/i do |m|
  puts 'executing: domo'

  r = m.reply
  r.body = 'kun'
  Ariera.write_to_stream r

  false
end
