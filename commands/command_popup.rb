# -*- coding: utf-8 -*-
class CommandPopup

  # smbclient -M NETBIOSNAME -U FROMNAME

  # tell application "Finder"
  #   display dialog "Choose computer:" buttons ¬
  #     {"Workstation_1", "Workstation_2"} default button 2
  #   if the button returned of the result is "Workstation_1" then
  #     set machine_chosen to "eppc://Workstation_1:password@192.168.1.45"
  #   else
  #     set machine_chosen to "eppc://Workstation_2:password@192.168.1.46"
  #   end if
  #   display dialog "" default answer "How are you doing?" buttons ¬
  #     {"Cancel", "Send"} default button 2
  #   copy the result as list to {text_returned, button_pressed}
  # end tell
  
  # tell application "Finder" of machine machine_chosen
  #   activate
  #   beep
  #   display dialog text_returned buttons {"Cancel", "OK"} ¬
  #     default button 2 giving up after 30
  #   set the clipboard to the text_returned
  #end tell */                     
  
end
