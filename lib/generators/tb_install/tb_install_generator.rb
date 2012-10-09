class TbInstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def gem_installation
    gem 'bootstrap-sass'
#
    run 'bundle exec bundle install'
  end

  def installation_twitter_bootstrap
    inject_into_file 'app/assets/javascripts/application.js', "\n//= require bootstrap\n", :after => "//= require_tree ."

    if FileUtils.mv "app/assets/stylesheets/application.css", "app/assets/stylesheets/application.css.scss"
        say("application.css was successfully renemed in application.css.scss")
      else
        error("File was not succesfully renamed")
    end

    inject_into_file 'app/assets/stylesheets/application.css.scss', %{\n@import "bootstrap";\n}, :after => "*/"

    copy_file "application.html.erb", "app/views/layouts/application.html.erb", force: true

    git :add => '.'
    git :commit => '-m "Twitter bootstrap installed"'
  end
end
