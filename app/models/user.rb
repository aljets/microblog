# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  # Password, password_confirmation automagic
  has_secure_password
  # Has many microposts, reverts to default foreign key user_id
  # Dependent means destroy microposts when destroy user
  has_many :microposts, dependent: :destroy
  # Has many relationships with the foreign key "follower_id"
  # Dependent means destroy relationships when destroy user
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  # Associate user model with followed users through relationships table
  # Must specify source is the set of "followed" ids in this case
  # because using 'followed_users' over 'followeds'
  has_many :followed_users, through: :relationships, source: :followed
  # Similar for followers, must specify class b/c no ReverseRelationship
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  before_save { self.email.downcase! }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  private
    
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
