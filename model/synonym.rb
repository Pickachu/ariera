class Synonym < ActiveRecord::Base
  has_many :synonymable, :polymorphic => true
end
