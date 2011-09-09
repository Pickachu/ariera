# -*- coding: utf-8 -*-
message :chat?, :body => /^(\[[^\\]+\] )?adicionar .+/i do |m|
  puts 'executing adicionar'
  r = m.reply
  params = m.body.gsub(/^\[[^\\]+\] /, '').scan /"[^"]*"|'[^']*'|[^"'\s]+/
  
  case params[1]
  when 'estabelecimento'
    food_establishment = FoodEstablishment.new
    food_establishment.name = params[2]
    if food_establishment.save
      r.body = "Estabelecimento alimentício #{params[2]} criado."
    else
      r.body = ''
      
      food_establishment.errors.full_messages.each do |message|
        r.body += "#{message}\n"
      end
    end
  else
    r.body = "Entindade inexistente para adicionar: #{params[1]}"
  end

  write_to_stream r
end
