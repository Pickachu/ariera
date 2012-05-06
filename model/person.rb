class Person
  include Mongoid::Document
  has_many :points, :as => :pointable
  has_many :votes, :as => :votable
  has_many :choices, :class_name => "Vote"
  has_one :cowboy

  validates :name, :uniqueness => true, :presence => true

  scope :named, lambda { |name| where(:name => name)}

  field :name, type: String
  field :jid, type: String
  field :score, type: Fixnum

end
