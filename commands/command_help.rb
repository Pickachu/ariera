# -*- coding: utf-8 -*-
class Commands::Help
  include Command::Commandable

  guards ['ajuda.*', 'help.*', 'i need somebody,? help!?', 'bot,? ajuda ai', 'alguem me ajuda']
  parameter :command

  handle do |m, params|
    r = m.reply
    command = params[:command]

    unless command.nil?
      begin
        helped = Commands.const_get command[:name].downcase.capitalize

        if helped.docummented?
          help_for helped.help
        else
          r.body = "Comando #{command[:name]} ainda não possui documentação."
        end
      rescue NameError
        r.body = "Comando não encontrado: #{command[:name]}."
      end
    else
      commands = [
                ["pontuar | fail <pessoa> <motivo...>", "Adicionar|Remover ponto para pessoa"],
                ["<termo>++ | <termo>--", "Adicionar ponto para termo"],
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
      end
    r
  end

  protected

  # TODO pass to a helper class
  def help_for command
    text = "[#{command[:name]}] : #{command[:description]} \n"
    text += "Sintaxe: #{command[:syntax]} \n" if command.has_key? :syntax
    text += "Variações: #{command[:variants]} \n" if command.has_key? :variants
  end
end

Commands::Help.new
