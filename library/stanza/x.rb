class X < Blather::Stanza::Presence
  def self.new(node = nil, ver = nil)
    new_node = super :x
    new_node.x
    new_node.node = node
    new_node.ver = ver
    new_node
  end
  
  def x
    x = if self.class.registered_ns
          find_first('ns:x', :ns => self.class.registered_ns)
        else
          find_first('x')
        end
    
    unless x
      (self << (c = XMPPNode.new('x', self.document)))
      x.namespace = self.class.registered_ns
    end
    x
  end
  
end
