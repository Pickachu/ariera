class FoodEstablishment
  include Mongoid::Document
  validates_uniqueness_of :name
  # validates_presence_of :name

  field :name, type: String
  
  has_many :votes, :as => :votable
end
