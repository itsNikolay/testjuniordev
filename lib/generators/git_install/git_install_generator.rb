class GitInstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  
  def git_install
    git :init
    git :add => '.'
    git :commit => '-m "Initial import."'
  end
end
