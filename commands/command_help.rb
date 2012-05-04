# -*- coding: utf-8 -*-
class CommandHelp 
  include Command
  
  def initialize
    @guards = ['ajuda', 'help', 'i need somebody,? help!?', 'bot,? ajuda ai']
  end
  
  def execute m, params
    puts 'executing: ajuda'
    r = m.reply
    
    commands = [
                ["pontuar | fail <pessoa> <motivo...>", "Adicionar|Remover ponto para pessoa"],
                ["<termo>+1 | <termo>-1", "Adicionar ponto para termo"],
                ["roubar <ladrão> <vítima> <motivo...>", "Roubar pponto de pessoa para pessoa"],
                ["almoco [estabelecimento]", "Lista / Vota em estabelecimento para o almoço"],
                ["play | pause | next | previous | again", "Começa ou pausa ou passa ou volta ou toca dinovo a música atual"],
                ["volume+ | volume- | volume <valor>", "Começa ou pausa ou passa para próxima música"]
               ]

    body = "Comandos\n"
    commands.each do |command|
      body += format("%s => %s\n", *command)
    end

    body += format("%-40s %-s \n", "volume+ | volume- | volume <valor>", "Começa ou pausa ou passa para próxima música")
    body += format("%-40s %-s \n", "say|diga|fale|speak <texto>", "Diz o <texto> especificado")
    
    body += "\n\nAções\n"
    body += "Ações disponíveis: voto\n"
    body += format("%-40s %-s \n", "desfazer <ação>", "Desfaz ultima ação")
    
    body += "\n\nEntidades\n"
    body += "Entidades disponíveis: estabelecimento, pessoa\n"
    body += format("%-40s %-s \n", "adicionar <entidade> <nome>", "Adiciona entidade") # Done
    body += format("%-40s %-s \n", "listar <entidade> <nome>", "Lista registros para entidade (Suporta todas)")
    
  
    r.body = body
    Ariera.write_to_stream r
  end
end

CommandHelp.new.listen
