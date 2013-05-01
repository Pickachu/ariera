class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body, type: String


  embedded_in :branch
  belongs_to  :person
end
