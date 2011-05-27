module RailsDeadweight
  class ProjectRoutes
    
    def self.get_routes_for(project_root)
      `cd #{File.expand_path(project_root)}; rake routes`
    end
    
  end
end