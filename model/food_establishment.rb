class FoodEstablishment
  include Mongoid::Document
  include Mongoid::Timestamps

  validates_uniqueness_of :name
  # validates_presence_of :name

  field :name, type: String

  scope :named, lambda { |name| where(:name => name)}

  has_many :votes, :as => :votable
end
