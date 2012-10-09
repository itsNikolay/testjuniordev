class CommentsInstallGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path('../templates', __FILE__)


  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  def installation
    migration_template "db/migrate/create_comments.rb", "db/migrate/create_comments.rb"

    rake("db:migrate")
    rake("db:test:prepare")

    copy_file "app/models/comment.rb", "app/models/comment.rb"

    inject_into_file "app/models/post.rb", "\n  has_many :comments, as: :commentable\n", after: %{belongs_to :user}
    inject_into_file "config/routes.rb", "\n      resources :comments\n", after: /resources..posts.do\n/

    copy_file "app/controllers/comments_controller.rb", "app/controllers/comments_controller.rb"
    copy_file "app/views/comments/index.html.erb", "app/views/comments/index.html.erb"
    copy_file "app/views/comments/new.html.erb", "app/views/comments/new.html.erb"
    copy_file "app/views/comments/_comments.html.erb", "app/views/comments/_comments.html.erb"
    copy_file "app/views/comments/_form.html.erb", "app/views/comments/_form.html.erb"
    copy_file "app/views/posts/show.html.erb", "app/views/posts/show.html.erb", force: true

    inject_into_file "app/controllers/posts_controller.rb", after: /def.show\n.{1,}Post.find.params..id..\n/ do <<-RUBY
          @commentable = @post
          @comments = @commentable.comments
          @comment = Comment.new
      RUBY
    end


  end

  def add_user_to_comment
    inject_into_file "app/controllers/comments_controller.rb", "\n before_filter :authenticate_user!, only: [:new, :create]\n", after: %{class CommentsController < ApplicationController}

    generate :migration, "add_column_user_id_to_comments user_id:integer"

    rake("db:migrate")
    rake("db:test:prepare")

    inject_into_file "app/models/comment.rb", "\n  belongs_to :user\n", after: %{belongs_to :commentable, polymorphic: true}
    inject_into_file "app/models/user.rb", "\n  has_many :comments\n", after: %{has_many :posts}
    inject_into_file "app/controllers/comments_controller.rb", "\n    @comment.user_id = current_user.id\n", after: %{@comment = @commentable.comments.new(params[:comment])}

    gsub_file "app/views/posts/show.html.erb", /<a.href..#.>3.Comments<\/a>/, %{<%= link_to pluralize(@post.comments.count, 'comment'), post_path(@post) %>}
    gsub_file "app/views/posts/index.html.erb", /<a.href..#.>3.Comments<\/a>/, %{<%= link_to pluralize(post.comments.count, 'comment'), post_path(post) %>}

    directory "app/views/comments", "app/views/comments"

    copy_file "app/controllers/admin/comments_controller.rb", "app/controllers/admin/comments_controller.rb"

    directory "app/views/admin/comments", "app/views/admin/comments"

    gsub_file "config/routes.rb", /resources :posts do\nresources..comments/, "resources :posts do\n"

    inject_into_file "config/routes.rb", "\n  resources :comments\n", after: "namespace :admin do\n"

    gsub_file "app/views/layouts/admin/_admin_sidebar_menu.html.erb", /<a.href=.#.><i.class=.icon-comment.><\/i>.Comments.{1,}10<\/span><\/a>/ do
    <<-eos
    <li<% if params[:controller] == "admin/comments"%> class="active"<% end %>>
            <a href="<%= admin_comments_path %>"><i class="icon-comment"></i> Comments</a></li>
    eos
    end
  end

  def add_test
    copy_file "spec/factories/comments.rb", "spec/factories/comments.rb"
    copy_file "spec/models/comments_spec.rb", "spec/models/comments_spec.rb"

    git :add => '.'
    git :commit => '-m "Comments installed"'
  end
end
