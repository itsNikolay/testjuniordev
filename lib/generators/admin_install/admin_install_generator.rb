class AdminInstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def copy_tests
    copy_file "spec/requests/admin/admin_access_page.rb", "spec/requests/admin/admin_access_page.rb"
  end


  def installation
    copy_file "app/controllers/admin/base_controller.rb", "app/controllers/admin/base_controller.rb"
    copy_file "app/views/admin/base/index.html.erb", "app/views/admin/base/index.html.erb"

    inject_into_file 'config/routes.rb', :after => "Application.routes.draw do" do
    <<-eos
    \nnamespace :admin do
      root :to => "base#index"
    end
    eos
    end

    copy_file "app/views/layouts/admin/admin.html.erb", "app/views/layouts/admin/admin.html.erb"
    copy_file "app/views/layouts/admin/_admin_sidebar_menu.html.erb", "app/views/layouts/admin/_admin_sidebar_menu.html.erb"
    copy_file "app/views/layouts/admin/_navigation.html.erb", "app/views/layouts/admin/_navigation.html.erb"

    inject_into_file 'app/views/layouts/_navigation.html.erb', "\n<li><%= link_to 'Admin', admin_root_path %></li>", :after => %{<%= link_to 'Login', new_user_session_path %>  \n    </li>\n  <% end %>}

    git :add => '.'
    git :commit => '-m "Admin panel installed"'
  end
end
