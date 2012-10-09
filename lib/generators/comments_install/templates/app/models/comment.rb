class Comment < ActiveRecord::Base
  attr_accessible :content
  validates :content,  presence: true, length: { maximum: 1000 }
  belongs_to :commentable, polymorphic: true
end