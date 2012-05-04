class Person < ActiveRecord::Base
  validates :name, :uniqueness => true, :presence => true

  has_many :points, :as => :pointable
  has_many :votes, :as => :votable
  has_many :choices, :class_name => "Vote"
  has_one :cowboy
end
