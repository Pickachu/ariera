class Synonym
  include Mongoid::Document
  has_many :synonymable, :polymorphic => true
end
