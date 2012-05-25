module Commands
  class MinusMinus
    include Command::Commandable
    
    guard '.*[-]{2}'
    
    # TODO
    # adium do
    #   guard '.*[—]'
    # end


    # TODO Quotation suport
    handle do |m|
      minuses = m.body.scan /([^\b\s]+)(?=[-]+)/
      r = m.reply
      r.body = ''
  
      minuses.each do |minus|
        term = Term.find_or_create_by(:name => minus[0].gsub('-', ''))
        term.points.create :amount => -1, :reason => 'Term ponctuation.'

        term.score ||= 0
        term.score -= 1
    
        if term.save
          r.body += "\n" unless r.body.blank?
          r.body += "Woohoo\!\!\! #{term.name} agora com #{term.score} pontos"
        end
      end
      r
    end
  end
end
    
Commands::MinusMinus.new
