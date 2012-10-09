require 'rails/generators'
require 'rails/generators/migration'

class DeviseInstallGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path('../templates', __FILE__)

  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  def gem_installation
    gem 'devise'

    run 'bundle'
  end

  def devise_installation
    inject_into_file 'config/environments/development.rb', "\nconfig.action_mailer.default_url_options = { :host => 'localhost:3000' }\n", :after => "Application.configure do"
    inject_into_file 'config/environments/test.rb',        "\nconfig.action_mailer.default_url_options = { :host => 'localhost:7000' }\n", :after => "Application.configure do"
    inject_into_file 'config/environments/production.rb',  "\nconfig.action_mailer.default_url_options = { :host => 'gmail.com' }\n", :after => "Application.configure do"

    generate("devise:install")
    generate(:devise, "user")
    generate "devise:views"

    rake("db:migrate")
    rake("db:test:prepare")

    copy_file "user.rb", "app/models/user.rb", force: true
    copy_file "_messages.html.erb", "app/views/layouts/_messages.html.erb"
    copy_file "_navigation.html.erb", "app/views/layouts/_navigation.html.erb"

    remove_file "spec/models/user_spec.rb"
    remove_file "spec/factories/users.rb"

    inject_into_file 'spec/factories.rb', :after => "FactoryGirl.define do", :force => true do
      <<-RUBY

      factory :user do
        nickname Faker::Name.first_name
        email Faker::Internet.email
        password "foobar"
        password_confirmation "foobar"
        avatar File.open("#\{Rails.root}" + '/spec/hamster.jpg')
      end
      RUBY
    end

    copy_file "spec/models/user_spec.rb", "spec/models/user_spec.rb"
    copy_file "spec/requests/user_pages_spec.rb", "spec/requests/user_pages_spec.rb"
    copy_file "spec/support/utilities.rb", "spec/support/utilities.rb"
    copy_file "spec/hamster.jpg", "spec/hamster.jpg"

    if yes? "Add admin to users?"
      migration_template "add_admin_to_user.rb", "db/migrate/add_admin_to_user.rb"

      inject_into_file 'spec/factories.rb', :after => /spec.hamster.jpg..\n/, :force => true do
        <<-RUBY
        \n\n\t\tfactory :admin do
          admin true
        end
        RUBY
      end

      rake("db:migrate")
      rake("db:test:prepare")

      rakefile("devise.rake") do <<-TASK
        namespace :db do
          desc "Add admin user"
          task populate: :environment do
            u = User.create!(email: "itsnikolay@gmail.com",
             password: "123123",
             password_confirmation: "123123")
            u.update_attribute :admin, true
            end
        end
        TASK
      end

      rake("db:populate")
    end
  end


    def add_users_profile
      if yes? "Create user profile?"
        generate :migration, "add_nickname_to_user nickname:string"
        rake("db:migrate")
        rake("db:test:prepare")

        inject_into_file "app/views/devise/registrations/new.html.erb", "\n  <%= f.input :nickname, :autofocus => true %>",
        after: %{<div class="form-inputs">}
        inject_into_file "app/views/devise/registrations/edit.html.erb", "\n  <%= f.input :nickname, :autofocus => true %>",
        after: %{<div class="form-inputs">}
        inject_into_file "app/models/user.rb", ", :nickname",
        after: /attr_accessible.{1,}:remember_me/
        inject_into_file "app/models/user.rb", after: /validates.{1,}password_confirmation.{1,}presence.{1,}true/ do
          <<-RUBY
          \n  validates :nickname, length: { maximum: 16 }
          RUBY
        end

        inject_into_file "config/routes.rb", "\n  resources :profiles, only: [:show]", after: %{Application.routes.draw do}

        copy_file "profiles_controller.rb", "app/controllers/profiles_controller.rb"
        copy_file "show.html.erb", "app/views/profiles/show.html.erb"

        gem 'paperclip'
        run 'bundle'

        inject_into_file "app/models/user.rb", ", :avatar", after: /attr_accessible.{1,}:remember_me/
        inject_into_file "app/models/user.rb", %{\n  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/assets/missing.png"}, after: /attr_accessible.{1,}email.{1,}\n/
        copy_file "missing.png", "app/assets/images/missing.png"

        generate :paperclip, "user avatar"

        rake("db:migrate")
        rake("db:test:prepare")

        inject_into_file "app/views/devise/registrations/edit.html.erb", %{:multipart => true, }, after: /form_for.{1,}html.{1,}{/
        inject_into_file "app/views/devise/registrations/edit.html.erb", %{\n <%= f.input :avatar, inline_label: 'Avatar for user' %>\n}, after: /<%=.{1,}input.{1,}current_password.{1,}%>/

        git :add => '.'
        git :commit => '-m "Devise installed"'
      end
    end
end
