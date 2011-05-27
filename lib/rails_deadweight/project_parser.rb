module RailsDeadweight
  class ProjectParser
    
    METHOD_DEFINITION_PATTERN = /def ([\.a-zA-Z0-9_\!\?]*)/
        
    def initialize(project_as_string, project_root)
      @project_as_string = project_as_string
      @project_root = project_root
    end
    
    def get_defined_methods
      method_definitions = @project_as_string.scan METHOD_DEFINITION_PATTERN
      methods = method_definitions.map do |method|
        method.to_s.gsub("self.", "")
      end
      
      methods.reject do |method|
        method.empty? || method == "initialize"
      end
    end
    
    def count_method_calls_for(method_name)
      method_call_pattern = Regexp.new("(filter(\s)+:#{method_name}|^#{method_name}|(def)?[\.\s\{\(]#{method_name})")
      method_calls = @project_as_string.scan method_call_pattern
      
      method_calls = method_calls.map do |method|
        method.to_s
      end
      
      method_calls = method_calls.reject do |method|
        method.match /^def/
      end
      
      return method_calls.count
    end
    
    def count_routes_for(action_name)
      @routes_string ||= ProjectRoutes.get_routes_for @project_root
      
      unless @routes_string.include? ":action"
        raise "Could not get project routes. Please make sure you're running rails_deadweight from within your application's root directory"
      end
      
      route_pattern = Regexp.new(":action=>\"#{action_name}\"")
      return @routes_string.scan(route_pattern).count
    end
  end
end