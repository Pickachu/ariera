# -*- coding: utf-8 -*-
class Commands::Rule
  include Command::Commandable
  
  guards ['rule \d+', 'rules \d+', 'regras \d+', 'regra \d+']
  parameter :number

  help :syntax => 'regra <numero...>', :variants => [:rules, :rule, :regra, :regras], :description => 'Exibe regra da internet.'

  handle do |m, params|
    r = m.reply
    r.body = ''
    
    puts params.inspect

    if params[:number]
      numbers = params[:number][:modifier].split(' ')
      numbers.each do |number|
        rule = Rule.numbered(number).first
        
        if rule
          r.body += "Regra #{rule.number}: #{rule.name} \n"
        else
          r.body += "Regra número #{number} não encontrada. \n"
        end
      end
    else
      r.body = "Número da regra inválido"
    end
    
    r.body = r.body.chomp
    r
  end
end

# TODO Instantiate classes out of here
Commands::Rule.new
