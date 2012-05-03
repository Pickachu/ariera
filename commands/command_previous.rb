# -*- coding: utf-8 -*-
class CommandPrevious
  include Command

  def initialize
    @guards = ['previous', 'prev', 'anterior']
    @parameters = [:amount]
    listen
  end

  def execute m, params
    # @todo Encapsular na classe command daqui
    puts 'executing previous'
    `osascript /Users/heitor/Development/Workspace/Ruby/ariera/scripts/execute_javascript_on_tab.scpt Grooveshark "Grooveshark.previous()"`
    `osascript /Users/heitor/Development/Workspace/Ruby/ariera/scripts/execute_javascript_on_tab.scpt Grooveshark "Grooveshark.previous()"`

  end
end

# TODO Instantiate classes out of here
CommandPrevious.new
