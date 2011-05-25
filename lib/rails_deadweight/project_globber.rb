module RailsDeadweight
  class ProjectGlobber
    
    def self.get_globbed_project(project_root)
      app_root = File.expand_path(project_root) + "/app"
      puts app_root
    end
    
  end
end