class Person < ActiveRecord::Base
  has_many :points, :as => :pointable
end