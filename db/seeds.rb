# encoding: utf-8

#Before seeding we have to destroy all previous data.
User.delete_all
Post.delete_all
Comment.delete_all

title1 = %{Мост Кеннеди (Бонн)}
text1 = %{Мост Кеннеди (нем. Kennedybrücke) — стальной сварной арочный мост через Рейн, расположенный в городе Бонне (Германия, федеральная земля Северный Рейн — Вестфалия) на расстоянии 654,9 км от истока реки. Мост соединяет городские районы Бёйель и Бонн (de: Bonn (Stadtbezirk)). По мосту проходит федеральная автодорога B56 (de: Bundesstraße 56).}

title2 = %{Боа-Виста (аэропорт)}
text2 = %{Международный аэропорт Боа-Виста – Атлас Бразил Кантанеди (порт. Aeroporto Internacional de Boa Vista - Atlas Brasil Cantanhede) (Код ИАТА: BVB) — бразильский аэропорт, расположенный в городе Боа-Виста, штат Рорайма.}

comment1 = %{Хорошая статья. Жду продолжения.}
comment2 = %{Могу выложить фотографии данного места.}

3.times do |n|
  email = "example#{n}@email.com"
    password = "foobar"
    user = User.create! email: email,
                        password: password,
                        password_confirmation: password
  3.times do |b|
    post1 = user.posts.create! title: title1, text: text1, published: true, tag_list: "тег-для-популярного, тег-для-нового, тег-для-полезного"
    post2 = user.posts.create! title: title2, text: text2, published: false, tag_list: "тег-для-пользователей, тег-для-гостей, тег-для-раскрутки"
    3.times do |c|
      postcomment1 = post1.comments.build content: comment1
      postcomment1.user = user
      postcomment1.save!
      postcomment2 = post1.comments.build content: comment2
      postcomment2.user = user
      postcomment2.save!
      postcomment1 = post2.comments.build content: comment1
      postcomment1.user = user
      postcomment1.save!
      postcomment2 = post2.comments.build content: comment2
      postcomment2.user = user
      postcomment2.save!
    end
  end
end


