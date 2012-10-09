class TestsInstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)


  def gems_install
    gem_group :development, :test do
      gem 'rspec-rails', '2.10.0'
      gem 'guard'
      gem 'guard-rspec', '0.5.5'
      gem 'rb-inotify', '0.8.8'
      gem 'guard-spork', '0.3.2'
      gem 'spork', '0.9.0'
      gem 'factory_girl_rails', '1.4.0'
      gem 'database_cleaner', '0.7.0'
      gem 'capybara'
      gem 'launchy'
      gem 'selenium-webdriver'
      gem 'capybara-mechanize'
      gem 'faker'
    end

    gsub_file 'Gemfile', "gem 'sqlite3'", "gem 'sqlite3', :group => [ :development, :test ]"

    run 'bundle'
  end

  def coping_templates
    copy_file "home_spec.rb", "spec/requests/home_spec.rb"
    copy_file "database_cleaner.rb", "spec/support/database_cleaner.rb"
    copy_file "factories.rb", "spec/factories.rb"
  end

  def installation_and_checking_tests
    run "rm public/index.html"

    generate("rspec:install")

    run 'bundle exec spork rspec --bootstrap'
    run 'bundle exec guard init spork'
    run 'bundle exec guard init rspec'

    gsub_file 'Guardfile', "guard 'rspec', :version => 2 do", "guard 'rspec', :version => 2, :cli => '--drb' do"
    gsub_file 'spec/spec_helper.rb', 'config.fixture_path', "#config.fixture_path"
    gsub_file 'spec/spec_helper.rb', 'config.use_transactional_fixtures', "#config.use_transactional_fixtures"

    inject_into_file 'config/application.rb', :after => "class Application < Rails::Application" do
      <<-eos

      config.generators do |g|
        g.test_framework :rspec,
          :fixtures => false,
          :view_specs => false,
          :helper_specs => false,
          :routing_specs => false,
          :controller_specs => false,
          :request_specs => false
        #g.fixture_replacement :factory_girl, :dir => "spec/factories"
      end
      eos
    end

    generate(:controller, "base index")

    gsub_file 'config/routes.rb', 'get "base/index"', "root :to => 'base#index'"

    git :add => '.'
    git :commit => '-m "Testing installed"'

  end
end
