class Unhandled
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message, type: String
  field :from, type: String
end                  
