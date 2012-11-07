# -*- coding: utf-8 -*-
module Commands
  class Polu
    include Command::Commandable

    guard 'polu'
    help :syntax => 'polu', :description => 'Chinga luis, principalmente quando não há internet'

    handle do |message, params|
      porra
      "Porra Luis!"
    end

    def porra
      `afplay "/Users/heitor/Live/Station/Porra\ Luis\!.mp4" &> /dev/null`
    end
  end
end

# TODO Automatic instatiation of commands
Commands::Polu.new
