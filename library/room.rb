class Room
  def initialize name
    join = Blather::Stanza::Presence::MUC.new
    join.to = "#{generated_id}@groupchat.google.com/heitor.salazar"

    puts ""
    puts ""
    puts ""
    puts join

    Ariera.write_to_stream join
  end

  def generated_id
    # private-chat-00000000-0000-0000-0000-000000000000
    'private-chat-00000000-0000-domo-0000-000000000000'
  end
end
