module RailsDeadweight
  class ProjectCrawler
    
    RUBY_FILE_EXTENSIONS = [".rb", ".erb", ".rjs", ".rhtml", ".builder", ".rake"]
    
    def self.get_project_files(root_path)
      files = self.get_ruby_files(root_path + "/app")
      files.concat self.get_ruby_files(root_path + "/lib")
      
      return files
    end
    
    def self.get_test_files(root_path)
      tests = []
      tests.concat self.get_ruby_files(root_path + "/spec") if(File.exist? root_path + "/spec")
      tests.concat self.get_ruby_files(root_path + "/test") if(File.exist? root_path + "/test")
      
      return tests
    end
    
    def self.get_ruby_files(root_path)
      file_paths = []
      RUBY_FILE_EXTENSIONS.each do |extension|
        file_paths.concat Dir[root_path + "/**/*#{extension}"]
      end
      
      files = []
      file_paths.each do |file_path|
        file_content = File.open(file_path).read
        files << {:path => file_path, :content => file_content}
      end
      
      return files
    end
    
  end
end