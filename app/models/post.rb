class Post < ActiveRecord::Base
  attr_accessible :published, :text, :title, :created_at, :tag_list

  validates_presence_of :text
  validates :title,  presence: true, length: { maximum: 80 }

  belongs_to :user
  has_many :comments, as: :commentable

  default_scope order('created_at DESC')
  scope :today, lambda { where("DATE(created_at) = '#{Date.today.to_s(:db)}'")}
  scope :by_current_user, lambda { |user| where(user_id: user.id) }
  scope :published, where(published: true)

  acts_as_taggable

end
