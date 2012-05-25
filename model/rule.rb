class Rule
  include Mongoid::Document
  field :number, type: Fixnum
  field :description, type: String

  scope :numbered, lambda { |number| where(:number => number) }
end
