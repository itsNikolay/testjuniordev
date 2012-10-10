# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'

User.delete_all
Post.delete_all
Comment.delete_all
3.times do |n|
    email = Faker::Internet.email
    password = "foobar"
    password_confirmation = "foobar"
    user = User.create!(email:    email,
                 password: password,
                 password_confirmation: password_confirmation)
    3.times do |b|
      post1 = user.posts.create! title: Faker::Lorem.sentence(5), text: Faker::Lorem.sentence(300), published: true, tag_list: "#{Faker::Lorem.sentence(1)}, #{Faker::Lorem.sentence(1)}, #{Faker::Lorem.sentence(1)}"
      post2 = user.posts.create! title: Faker::Lorem.sentence(5), text: Faker::Lorem.sentence(300), published: false, tag_list: "#{Faker::Lorem.sentence(1)}, #{Faker::Lorem.sentence(1)}, #{Faker::Lorem.sentence(1)}"
      3.times do |c|
        pc1 = post1.comments.build content: Faker::Lorem.sentence(10)
        pc1.user = user
        pc1.save!
        pc2 = post2.comments.build content: Faker::Lorem.sentence(10)
        pc2.user = user
        pc2.save!
      end
    end
  end