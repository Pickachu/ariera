class Room
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :people

  has_many :branches
  has_one  :current_branch, :class_name => "::Branch"

  field :name, type: String
  field :identity, type: String
end
