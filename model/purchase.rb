class Purchase
  include Mongoid::Document
  include Mongoid::Timestamps
                   
  belongs_to :person
  # Store all ids in the purchase
  has_and_belongs_to_many :products, :inverse_of => nil 

  field :value, type: Float
end              
