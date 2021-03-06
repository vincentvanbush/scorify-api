class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :event

  field :content, type: String
  field :attachment_url, type: String

  validates :content, presence: true, length: { maximum: 300 }
  validates :attachment_url, length: { maximum: 150 }

  scope :after, ->(timestamp) {
    datetime = DateTime.strptime(timestamp.to_s, '%s')
    where(:created_at.gt => datetime)
  }
end
