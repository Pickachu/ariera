class Term
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :points, :as => :pointable

  field :name, type: String
  field :score, type: Fixnum
end
