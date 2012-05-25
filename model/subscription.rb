class Subscription
  include Mongoid::Document
  include Mongoid::Timestamps


  # TODO change to e from, to persons
  field :to, type: String
  field :from, type: String
  field :type, type: String
end
