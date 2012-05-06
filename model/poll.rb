class Poll
  include Mongoid::Document
  has_many :votes, :as => :votable
  belongs_to :person

  field :name, type: String
  field :state, type: String

  validates :name, :presence => true, :uniqueness => true

  scope :frank, where(:state => :active)
end
