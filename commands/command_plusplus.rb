module Commands
  class PlusPlus
    include Command::Commandable

    guard '.*[+]{2}'

    # TODO Quotation suport
    handle do |m|
      pluses = m.body.scan /([^\b\s]+)(?=[+]+)/

      r = m.reply
      r.body = ''

      pluses.each do |plus|
        term = Term.find_or_create_by(:name => plus[0].gsub('+', ''))
        term.points.create :amount => 1, :reason => 'Term ponctuation.'
        
        term.score ||= 0
        term.score += 1
        

        if term.save
          r.body += "\n" unless r.body.blank?
          r.body += "Woohoo\!\!\! #{term.name} agora com #{term.score} pontos"
        end
      end
      
      r
    end
  end
end

Commands::PlusPlus.new
