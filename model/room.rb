class Room
  include Mongoid::Document
  include Mongoid::Timestamps
  
  has_many :people

  field :name, type: String
  field :identity, type: String
end                        
