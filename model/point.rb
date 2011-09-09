class Point < ActiveRecord::Base
      belongs_to :pointable, :polymorphic => true
end