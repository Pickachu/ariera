# -*- coding: utf-8 -*-
Ariera.message :chat?, :body => /^(\[[^\\]+\] )?isabella.*/i do |m|
  r = m.reply

  frases = ['a mulher mais legal de todas.', 'a mulher mais linda de todas', 'a mulher mais amavel de todas.', 'a mulher mais espotânea de todas']

  r.body = 'Isabella é ' + frases[(rand * frases.size).floor]
  puts 

  Ariera.write_to_stream r
end 
