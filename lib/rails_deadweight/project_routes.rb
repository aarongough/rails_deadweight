module RailsDeadweight
  class ProjectRoutes
    
    def self.get_routes_for(project_root)
      result = `cd #{project_root}; rake routes 2>&1`
      puts "ROUTES:" + result
      return result
    end
    
  end
end