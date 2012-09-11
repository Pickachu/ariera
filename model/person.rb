class Person
  include Mongoid::Document
  has_many :points, :as => :pointable
  has_many :votes, :as => :votable
  has_many :choices, :class_name => "Vote"
  has_one :cowboy
  has_many :polls
  belongs_to :room

  validates :name, :uniqueness => true, :presence => true

  scope :named, lambda { |name| where(:name => name)}
  scope :identified_by, lambda { |identity| where(:identity => identity)}

  field :name, type: String
  field :pseudonym, type: String
  field :identity, type: String
  field :score, type: Fixnum

  def nickname
    pseudonym || name || identity
  end

end
