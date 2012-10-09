class SfInstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def gems_installation
    gem 'simple_form'

    run "bundle exec bundle install"

    generate("simple_form:install --bootstrap")

    git :add => '.'
    git :commit => '-m "Simple form installed"'
  end
end
