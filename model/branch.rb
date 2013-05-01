class Branch
  include Mongoid::Document
  include Mongoid::Timestamps
  include Workflow

  scope :by_room, lambda { |room| where(:room_jid => room.jid) }

  field :name, type: String
  field :state, type: Symbol, :defualt => :open


  belongs_to  :room
  belongs_to  :person

  belongs_to  :related_branch, :class_name => "Branch"
  belongs_to  :parent_branch, :class_name => "Branch"

  embeds_many :messages

  def merge branch = nil
    related_branch = branch or parent_branch
  end

  workflow do
    state :opened do
      event :merge, :transition_to => :merged
    end

    state :merged
  end
end
