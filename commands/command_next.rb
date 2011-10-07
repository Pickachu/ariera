Ariera.message :chat?, :body => /^(\[[^\\]+\] )?next.*/i do |m|
  system('osascript /Users/heitor/Development/Workspace/Ruby/ariera/scripts/execute_javascript_on_tab.scpt Grooveshark "Grooveshark.next()"')
end 
