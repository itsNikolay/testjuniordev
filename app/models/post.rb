class Post < ActiveRecord::Base
  attr_accessible :published, :text, :title, :created_at

  validates_presence_of :text
  validates :title,  presence: true, length: { maximum: 80 }

  belongs_to :user

  scope :today, lambda { where("DATE(created_at) = '#{Date.today.to_s(:db)}'").order('created_at DESC')}

  scope :by_current_user, lambda { |user| where(user_id: user.id) }

end
