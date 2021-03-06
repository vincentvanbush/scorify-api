class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :events

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  def votes_for
    self.events.collect { |e| e.votes }.flatten
  end

  def positive_votes
    votes_for.select { |v| v.positive? == true }.count
  end

  def negative_votes
    votes_for.select { |v| v.positive? == false }.count
  end

  field :facebook_id,         type: String, default: ""
  field :twitter_id,          type: String, default: ""
  field :auth_token,          type: String, default: ""

  validates_uniqueness_of :auth_token
  

  before_create :generate_authentication_token!

  def generate_authentication_token!
    begin
     self.auth_token = Devise.friendly_token
    end while User.where(auth_token: auth_token).exists?
  end
end
