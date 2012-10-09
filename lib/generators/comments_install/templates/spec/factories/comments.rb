FactoryGirl.define do
  factory :comment do
    content Faker::Lorem.paragraph(10)
    user { User.first || Factory(:user) }
    commentable { Post.first || Factory(:post) }

    factory :comment2 do
      content Faker::Lorem.paragraph(10)
      user { User.find_by_admin(true, :limit => "1") || Factory(:admin) }
      commentable { Post.first || Factory(:post) }
    end
  end
end