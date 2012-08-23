class Micropost < ActiveRecord::Base
  # Can only access micropost.content directly. To create micropost must
  # use user.micropost (allowed via one to many, many to one relationship)
  attr_accessible :content
  # Allows for one to many, many to one relationship
  belongs_to :user
  
  # Requires micropost content with max length of 140 chars
  validates :content, presence: true, length: { maximum: 140 }
  # Requires user_id on micropost creation
  validates :user_id, presence: true

  # Sets user.microposts default order to descending by daate
  default_scope order: 'microposts.created_at DESC'

  # Returns microposts from the users being followed by the given user and the 
  # user's own microposts
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user)
  end
end
