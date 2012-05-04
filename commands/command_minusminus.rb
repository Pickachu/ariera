# Ariera.message :chat?, :body => /[-][\d]/ do |m|
#   puts 'executing: minus minus'
#   r = m.reply
#   minuses = m.body.scan /([^\b\s]+)(?=[-][\d])/
  
#   minuses.each do |minus|
#     term = Term.find_or_create_by_term(minus[0])
#     point = Point.new :reason => 'Term ponctuation.'
#     point.amount = -1
#     term.points << point
#     term.score -= 1
    
#     if term.save
#       if r.body.nil?
#         r.body = ''
#       else
#         r.body += "\n"
#       end
      
#       r.body += "Woohoo\!\!\! #{term.term} agora com [#{term.score}]"
#     end
#   end
  
#   write_to_stream r
# end
