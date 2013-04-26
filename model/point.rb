class Point
  include Mongoid::Document
  # include Mongoid::Timestamps

  validates_presence_of :reason

  field :amount, type: Fixnum
  field :reason, type: String

  field :created_at, type: String
  field :updated_at, type: String

  belongs_to :pointable, :polymorphic => true
  belongs_to :person
end
