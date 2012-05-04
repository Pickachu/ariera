Ariera.message :chat?, :body => /[+][\d]/ do |m|
  puts 'executing: plus plus'

  r = m.reply
  pluses = m.body.scan /([^\b\s]+)(?=[+][\d])/

  pluses.each do |plus|
    term = Term.find_or_create_by_term(plus[0])
    point = Point.new :reason => 'Term ponctuation.'
    term.points << point
    term.score += 1
    
    if term.save
      r.body = "\n Woohoo\!\!\! #{term.term} agora com #{term.score} pontos."
    end
  end
  
  Ariera.write_to_stream r
end
