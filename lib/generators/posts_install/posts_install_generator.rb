class PostsInstallGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path('../templates', __FILE__)

  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  def gem_dependencies_installation
    gem "ckeditor", version: "3.7.1"
    gem "paperclip"

    run "bundle exec bundle"
  end

  def posts_install
    generate "ckeditor:install --orm=active_record --backend=paperclip"
    inject_into_file "config/routes.rb", %{\n  mount Ckeditor::Engine => "/ckeditor"}, :after => "Application.routes.draw do"
    inject_into_file "config/environments/production.rb", %{\n  config.assets.precompile += Ckeditor.assets\n}, :after => "Admin::Application.configure do"
    inject_into_file "app/assets/javascripts/application.js", %{\n//= require ckeditor/init\n}, :after => "//= require_tree ."


    inject_into_file 'app/models/user.rb', "  has_many :posts\n", :before => "end"

    copy_file "post.rb", "app/models/post.rb"

    migration_template "db/migrate/create_posts.rb", "db/migrate/create_posts.rb"
    sleep 1
    migration_template "db/migrate/add_user_id_to_post.rb", "db/migrate/add_user_id_to_post.rb"

    rake "db:migrate"
    rake "db:test:prepare"

    copy_file "app/controllers/admin/posts_controller.rb", "app/controllers/admin/posts_controller.rb"
    directory 'app/views/admin/posts', 'app/views/admin/posts'
    directory 'app/views/posts/', 'app/views/posts/'

    gsub_file 'config/routes.rb', "resources :posts", "resources :posts, only: [:index, :show]"
    inject_into_file "config/routes.rb", "\n    resources :posts do\n    end", :after => "namespace :admin do"

    gsub_file 'app/views/layouts/admin/_admin_sidebar_menu.html.erb', /<a.{1,}###POSTS.{1,}\n\n.{1,}/ do
    <<-eos
    <li<% if params[:controller] == "admin/posts"%> class="active"<% end %>>
            <a href="<%= admin_posts_path %>"><i class="icon-list-alt"></i> Posts</a></li>
    eos
    end
    copy_file "app/controllers/posts_controller.rb", "app/controllers/posts_controller.rb"

    gsub_file "config/routes.rb", "root :to => 'base#index'", "root :to => 'posts#index'"

  end

  def add_image_to_post
    if yes? "Add image_to_post?"
      gem 'paperclip'
      run 'bundle'

      generate :paperclip, "post avatar"
      rake "db:migrate"
      rake "db:test:prepare"

      inject_into_file "app/models/post.rb", " , :avatar", after: /attr_accessible.{1,}:title/
      inject_into_file "app/models/post.rb", %{\n  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }}, after: /validates_uniqueness_of..slug/

      inject_into_file "app/views/admin/posts/_form.html.erb", %{:multipart => true, }, after: /form_for.{1,}html.{1,}{/
      inject_into_file "app/views/admin/posts/_form.html.erb", %{<%= f.input :avatar, inline_label: 'Avatar for post' %>\n}, before: /<%=.{1,}input.{1,}published.{1,}%>/

      gsub_file "app/views/posts/index.html.erb", /<a href.{1,}thumbnail.{1,}\n.{1,}placehold.it.{1,}alt="">/, %{<%= link_to image_tag(post.avatar.url(:medium)), post_path(post), { class: 'thumbnail' } %>}
      gsub_file "app/views/posts/show.html.erb", /<a href.{1,}thumbnail.{1,}\n.{1,}placehold.it.{1,}alt="">/, %{<%= link_to image_tag(@post.avatar.url(:medium)), post_path(@post), { class: 'thumbnail' } %>}
    end
  end

  def published
    inject_into_file "app/models/post.rb", %{\n  scope :published, where(published: true)\n}, before: /private/
    gsub_file 'app/controllers/posts_controller.rb', "@post = Post.all", "@post = Post.published"
  end

  def copy_tests

    inject_into_file "spec/factories.rb", after: /FactoryGirl.define do\n/ do <<-RUBY
      factory :post do
        title Faker::Lorem.characters(80)
        slug Faker::Lorem.characters(80)
        description Faker::Lorem.characters(200)
        text Faker::Lorem.paragraph(10)
        published true
        avatar File.open("#{Rails.root}" + '/spec/hamster.jpg')
        user { User.find_by_admin(true) || Factory(:admin) }

        factory :unpublished_post do
          slug Faker::Lorem.characters(79)
          published false
        end
      end\n
      RUBY
    end

    copy_file "spec/requests/admin/admin_post_pages_spec.rb", "spec/requests/admin/admin_post_pages_spec.rb"
    copy_file "spec/models/post_spec.rb", "spec/models/post_spec.rb"
    copy_file "spec/requests/post_pages_spec.rb", "spec/requests/post_pages_spec.rb"

    git :add => '.'
    git :commit => '-m "Posts installed."'
  end

end
