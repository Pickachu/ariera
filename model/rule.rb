class Rule
  include Mongoid::Document
  field :number, type: Fixnum
  field :description, type: String
end
