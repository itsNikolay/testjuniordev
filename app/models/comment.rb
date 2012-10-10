class Comment < ActiveRecord::Base
  attr_accessible :content
  validates :content,  presence: true, length: { maximum: 300 }
  belongs_to :commentable, polymorphic: true

  belongs_to :user
end