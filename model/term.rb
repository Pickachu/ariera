class Term < ActiveRecord::Base
      has_many :points, :as => :pointable
end