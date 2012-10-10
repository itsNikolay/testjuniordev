FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    password "foobar"
    password_confirmation "foobar"
  end

  factory :post do
    title "New post"
    text Faker::Lorem.paragraph(10)
    published true
    created_at Time.now
    user { User.first || FactoryGirl.create(:user) }
  end

end