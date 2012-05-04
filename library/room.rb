class Room
  def initialize name
    presence = Blather::Stanza::Presence::X.new

    puts presence
    # Ariera.write_to_stream presence
  end
end
