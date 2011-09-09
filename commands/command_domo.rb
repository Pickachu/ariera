message :chat?, :body =>  /(\[[^\]]*\])? domo/i do |m|
  puts 'executing: domo'

  r = m.reply
  r.body = 'kun'
  write_to_stream r
end
