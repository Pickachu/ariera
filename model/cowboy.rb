class Cowboy < ActiveRecord::Base
  # validates_presence_of :reason
  belongs_to :person
end
