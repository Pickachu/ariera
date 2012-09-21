# -*- coding: utf-8 -*-
module Commands
  class Round
    include Command::Commandable

    guards ['round', 'repeat', 'again', 'dinovo', 'restart']
    parameter :amount

    handle do |m, params|
      # @todo Encapsular na classe command daqui
      `osascript /Users/heitor/Development/Workspace/Ruby/ariera/scripts/execute_javascript_on_tab.scpt Grooveshark "Grooveshark.previous()"`
    end
  end
end

# TODO Instantiate classes out of here
Commands::Round.new
