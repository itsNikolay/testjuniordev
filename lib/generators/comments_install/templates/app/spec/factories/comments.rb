FactoryGirl.define do
  factory :comment do
    content Faker::Lorem.paragraph(10)
    user { User.find_by_admin(false) || Factory(:user) }

    factory :comment2 do
      content Faker::Lorem.paragraph(10)
      user { User.find_by_admin(true) || Factory(:admin) }
    end
  end
end