class Person < ActiveRecord::Base
  validates_uniqueness_of :name

  has_many :points, :as => :pointable
  has_many :votes, :as => :votable
  has_many :choices, :class_name => "Vote"
end
