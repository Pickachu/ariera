# -*- coding: utf-8 -*-
Ariera.message :chat?, :body => /^(\[[^\\]+\] )?pause.*/i do |m|
  system('osascript /Users/heitor/Development/Workspace/Ruby/ariera/scripts/execute_javascript_on_tab.scpt Grooveshark "Grooveshark.pause()"')
end 
