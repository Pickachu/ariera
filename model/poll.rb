class Poll < ActiveRecord::Base
  has_many :votes, :as => :votable
  belongs_to :person

  validates :name, :presence => true, :uniqueness => true

  scope :frank, where(:state => :active)
end
