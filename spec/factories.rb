FactoryGirl.define do

  Factory.sequence :sequenceemail do |n|
    "example#{n}@example.com"
  end

  factory :user do
    email Faker::Internet.email
    password "foobar"
    password_confirmation "foobar"

    factory :anotheruser do
      email { Factory.next(:sequenceemail)}
    end
  end

  factory :post do
    title "New post"
    text Faker::Lorem.paragraph(10)
    published true
    created_at Time.now
    user { User.first || FactoryGirl.create(:user) }

    factory :post2 do
      title "Another Post"
      association :user, factory: :anotheruser
      published true
    end

    factory :yesterdaypost do
      title "Title for post 2"
      created_at Date.yesterday
    end

    factory :unpublishedpost do
      published false
      title "Unpublished Post."
    end
  end

  factory :comment do
    content "Contnent for comment to a post"
    user { User.first || Factory(:user) }
    commentable { Post.first || Factory(:post) }
  end

end