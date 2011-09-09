# -*- coding: utf-8 -*-
message :chat?, 
[
 {:body => /(\[[^\]]*\] )?ajuda/i}, 
 {:body => /(\[[^\]]*\] )?help/i}, 
 {:body => /(\[[^\]]*\] )?i need somebody,? help!?/i}
] do |m|
  puts 'executing: ajuda'
  r = m.reply

  comandos = "Comandos\n"
  comandos += format("%-40s %-s \n", "Comando", "Descrição")
  comandos += format("%-40s %-s \n", "pontuar <pessoa> <motivo>", "Adicionar ponto para pessoa")
  comandos += format("%-40s %-s \n", "<termo>+1 ou <termo>-1", "Adicionar ponto para termo")
  comandos += format("%-40s %-s \n", "almoco [estabelecimento]", "Lista / Vota em estabelecimento para o almoço")
 
  comandos += "\n\nAções\n"
  comandos += "Ações disponíveis: voto\n"
  comandos += format("%-40s %-s \n", "desfazer <ação>", "Desfaz ultima ação")

  comandos += "\n\nEntidades\n"
  comandos += "Entidades disponíveis: estabelecimento\n"
  comandos += format("%-40s %-s \n", "adicionar <entidade> <nome>", "Adiciona entidade")
  
  r.body = comandos
  write_to_stream r
end
