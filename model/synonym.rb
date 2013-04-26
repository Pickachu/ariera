class Synonym
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :synonymable, :polymorphic => true
end
