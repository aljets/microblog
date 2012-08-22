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
end
