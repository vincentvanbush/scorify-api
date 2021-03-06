class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  belongs_to :discipline
  belongs_to :user
  embeds_many :messages
  embeds_many :contenders
  validates_presence_of :contenders
  embeds_many :comments
  has_many :votes

  field :title, type: String
  slug :title
  field :description, type: String
  field :venue, type: String
  field :start_date, type: DateTime
  field :finished?, type: Boolean, default: false

  validates_presence_of :title
  validates :description, length: { maximum: 200 }
  validates_presence_of :venue
  validates_presence_of :start_date
  validates_date :start_date, on_or_after: ->{ DateTime.now }
  validates_presence_of :finished?

  validates_presence_of :user
  validates_presence_of :discipline

  scope :finished, ->(fin){ where(finished?: fin) }

  def positive_votes
    self.votes.where(positive?: true).count
  end

  def negative_votes
    self.votes.where(positive?: false).count
  end
end
