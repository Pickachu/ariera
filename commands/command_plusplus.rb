message :chat?, :body => /[+][\d]/ do |m|
  puts 'executing: plus plus'

  r = m.reply
  pluses = m.body.scan /([^\b\s]+)(?=[+][\d])/

  pluses.each do |plus|
    term = Term.find_or_create_by_term(plus[0])
    point = Point.new :reason => 'Term ponctuation.'
    term.points << point
    term.score += 1
    
    if term.save
      if r.body.nil?
        r.body = ''
      else
        r.body += "\n"
      end
            
      r.body += "Woohoo\!\!\! #{term.term} agora com [#{term.score}]"
    end
  end
  
  write_to_stream r
end
