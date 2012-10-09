class Post < ActiveRecord::Base
  attr_accessible :description, :published, :slug, :text, :title

  belongs_to :user

  validates_presence_of :text
  validates :title,  presence: true, length: { maximum: 80 }
  validates_uniqueness_of :slug

  before_save { self.slug = self.slug.parameterize }

  def to_param
    "#{self.id}-#{self.slug}"
  end

 private

  def just_english_slugs_allowed
    errors.add :slug, "Just english slugs are allowed" if self.slug.parameterize == ""
  end

end
