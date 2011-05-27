module RailsDeadweight
  class ProjectGlobber
    
    RUBY_FILE_EXTENSIONS = [".rb", ".erb", ".rhtml", ".rjs"]
    
    def self.get_globbed_project(project_root)
      included_paths = [
        File.expand_path(project_root) + "/app",
        File.expand_path(project_root) + "/lib"
      ]
      project_files = []
      project_glob = ""
      
      included_paths.each do |path|
        RUBY_FILE_EXTENSIONS.each do |extension|
          project_files.concat Dir[path + "/**/*#{extension}"]
        end
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