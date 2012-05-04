class Point < ActiveRecord::Base
  # validates_presence_of :reason

  belongs_to :pointable, :polymorphic => true
  belongs_to :person
end
