# -*- coding: utf-8 -*-
module Commands
  class Help
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
            help = help_for helped.help
            r.body = help
            r.xhtml = format_documentation help
          else
            r.body = "Comando #{command[:name]} ainda não possui documentação."
          end
        rescue NameError
          r.body = "Comando não encontrado: #{command[:name]}."
        rescue Exception
          r.body = "erro"
        end
      else
        # Documentar
        # ["play | pause | next | previous | again", "Começa ou pausa ou passa ou volta ou toca dinovo a música atual"],
        # ["volume+ | volume- | volume <valor>", "Começa ou pausa ou passa para próxima música"]
#        body += format("%-40s %-s \n", "desfazer <ação>", "Desfaz ultima ação")
        # body += "\n\nEntidades\n"
        # body += format("%-40s %-s \n", "adicionar <entidade> <nome>", "Adiciona entidade") # Done
        # body += format("%-40s %-s \n", "listar <entidade> <nome>", "Lista registros para entidade (Suporta todas)")

        slices = []
        Commands.constants.each_slice(3) { |slice| slices << slice.map(&:downcase).join(', ') }
        commands_list = slices.join("\n")
        formatted_commands_list = slices.join("<br />")

        body = "Digite ajuda nome_do_comando para saber mais sobre o comando. \n"
        body += "Os parâmetros devem ser digitados sem '<' e '>'. Lista de comandos: \n"
        body += commands_list

        formatted_body = "Digite ajuda <u>nome_do_comando</u> para saber mais sobre o comando. <br />"
        formatted_body += "Lista de comandos: <br />"
        formatted_body += formatted_commands_list

        r.body = body
        r.body = formatted_body
      end
      r
    end

    protected

    def format_documentation body
      body.gsub('>', '</u>').gsub(/<([^\/])/, '<u>\1').gsub("\n", '<br />')
    end

    # TODO pass to a helper class
    def help_for command
      text = "[#{command[:name]}] : #{command[:description]} \n"
      text += "Sintaxe: #{command[:syntax]} \n" if command.has_key? :syntax
      text += "Variações: #{command[:variants].join(', ')} \n" if command.has_key? :variants
    end
  end
end

Commands::Help.new
