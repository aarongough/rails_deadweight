module RailsDeadweight
  class ProjectParser
    
    METHOD_DEFINITION_PATTERN = /def ([a-zA-Z0-9_\!\?]*)/
        
    def initialize(project_as_string)
      @project_as_string = project_as_string
    end
    
    def get_defined_methods
      method_definitions = @project_as_string.scan METHOD_DEFINITION_PATTERN
      method_definitions.map do |method|
        method.to_s
      end
    end
    
    def count_method_calls_for(method_name)
      0
    end
  end
end