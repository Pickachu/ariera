class Product
  include Mongoid::Document
  include Mongoid::Timestamps

  validates_uniqueness_of :name
  validates_presence_of :name
                   
  has_many :purchases
  field :name, type: String 
  field :kind, type: String 

  scope :today, where(:updated_at => Time.now.midnight..Time.now)
  scope :by, lambda { |person| where(:person_id => person.id) }

end
