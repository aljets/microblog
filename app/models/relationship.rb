class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  # Infers foreign keys from symbols ("follower_id" & "followed_id")
  # Need to specify class name User since no Followed or Follower model
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
