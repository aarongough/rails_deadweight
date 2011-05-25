module RailsDeadweight
  class ProjectGlobber
    
    RUBY_FILE_EXTENSIONS = [".rb", ".erb"]
    
    def self.get_globbed_project(project_root)
      app_root = File.expand_path(project_root) + "/app"
      project_files = []
      project_glob = ""
      
      RUBY_FILE_EXTENSIONS.each do |extension|
        project_files.concat Dir[app_root + "/**/*#{extension}"]
      end
      
      project_files.each do |path|
        File.open(path) do |file|
          project_glob << file.read
          project_glob << "\n"
        end
      end
      
      return project_glob
    end
    
  end
end