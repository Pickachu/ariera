class Vote
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :votable, :polymorphic => true
  belongs_to :person

  field :kind, type: String

  scope :today, where(:updated_at => Time.now.midnight..Time.now)
  scope :by, lambda { |person| where(:person_id => person.id) }

  scope :recent, desc(:updated_at)
end
