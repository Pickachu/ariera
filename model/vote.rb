class Vote
  include Mongoid::Document
  belongs_to :votable, :polymorphic => true
  belongs_to :person

  scope :today, where(:updated_at.gt => Time.mktime(Time.now.year, Time.now.month, Time.now.day), :updated_at.lt => Time.mktime(Time.now.year, Time.now.month, Time.now.day, 23, 59))
  
  scope :recent, desc(:updated_at)


end
