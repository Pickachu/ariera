class Vote < ActiveRecord::Base
  belongs_to :votable, :polymorphic => true
  belongs_to :person

  scope :today, where(['updated_at BETWEEN (?) AND (?)', Time.mktime(Time.now.year, Time.now.month, Time.now.day), Time.mktime(Time.now.year, Time.now.month, Time.now.day, 23, 59)])
  
  scope :recent, order('updated_at DESC')


end
