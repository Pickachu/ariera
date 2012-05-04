# -*- coding: utf-8 -*-
Ariera.message :chat?, [
                 {:body => /^(\[[^\\]+\] )?cinema.*/i},
                 {:body => /^(\[[^\\]+\] )?filmes?.*/i}
                ] do |m|
  r = m.reply
  r.body = 'Comando de gerenciamento de filmes não implementado ainda.'
  Ariera.write_to_stream r
end
