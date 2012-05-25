# -*- coding: utf-8 -*-
class Commands::Previous
  include Command::Commandable

  guards ['previous', 'prev', 'anterior']
  parameter :amount

  handle do |m, params|
    `osascript /Users/heitor/Development/Workspace/Ruby/ariera/scripts/execute_javascript_on_tab.scpt Grooveshark "Grooveshark.previous()"`
    `osascript /Users/heitor/Development/Workspace/Ruby/ariera/scripts/execute_javascript_on_tab.scpt Grooveshark "Grooveshark.previous()"`
  end
end

# TODO Instantiate classes out of here
Commands::Previous.new
