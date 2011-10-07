# -*- coding: utf-8 -*-
Ariera.message :chat?, :body => /^(\[[^\\]+\] )?karaoke.*/i do |m|
  r = m.reply
  r.body = 'Comando \'karaoke\' não implementado ainda.'
  write_to_stream r
end
