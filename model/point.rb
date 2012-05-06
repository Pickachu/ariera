class Point
  include Mongoid::Document
  # validates_presence_of :reason
  
  field :amount, type: Fixnum
  field :reason, type: String

  belongs_to :pointable, :polymorphic => true
  belongs_to :person
end
