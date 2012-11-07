class Purchase
  include Mongoid::Document
  include Mongoid::Timestamps
                   
  belongs_to :person
  has_many :products

  field :value, type: Float
end              
