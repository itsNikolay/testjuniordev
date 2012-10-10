require 'rubygems'
require 'factory_girl_rails'
# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Factory.create(:user)
15.times { Factory.create(:post, tag_list: "good, better, thebest") }
15.times { Factory.create(:unpublishedpost, tag_list: "another, and, other") }
15.times { Factory.create(:comment) }