#encoding: utf-8
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    
    user = User.find_by_email("example1@email.com")

    title1 = %{Мост Кеннеди (Бонн)}
    text1 = %{Мост Кеннеди (нем. Kennedybrücke) — стальной сварной арочный мост через Рейн, расположенный в городе Бонне (Германия, федеральная земля Северный Рейн — Вестфалия) на расстоянии 654,9 км от истока реки. Мост соединяет городские районы Бёйель и Бонн (de: Bonn (Stadtbezirk)). По мосту проходит федеральная автодорога B56 (de: Bundesstraße 56).}
    10.times do  |n|
      post1 = user.posts.create! title: title1, text: text1, published: true, tag_list: "тег-для-популярного, тег-для-нового"
    end
    20.times do  |n|
      post1 = user.posts.create! title: title1, text: text1, published: true, tag_list: "тег-для-популярного"
    end
  end
end