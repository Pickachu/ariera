# -*- coding: utf-8 -*-
class CommandRound
  include Command

  def initialize
    @guards = ['round', 'repeat', 'again', 'dinovo', 'restart']
    @parameters = [:amount]
    listen
  end

  def execute m, params
    # @todo Encapsular na classe command daqui
    puts 'executing round'
    `osascript /Users/heitor/Development/Workspace/Ruby/ariera/scripts/execute_javascript_on_tab.scpt Grooveshark "Grooveshark.previous()"`

  end
end

# TODO Instantiate classes out of here
CommandRound.new
