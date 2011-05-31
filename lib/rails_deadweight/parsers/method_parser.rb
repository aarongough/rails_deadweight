module RailsDeadweight
  module Parsers
    class MethodParser
      
      METHOD_DEFINITION_PATTERN = /def ([\.a-zA-Z0-9_\!\?]*)/
      
      def self.get_defined_methods(files)
        methods = []
        
        files.each do |file|
          raw_methods = file[:content].scan METHOD_DEFINITION_PATTERN
          
          raw_methods.each do |method|
            methods << {
              :file_path => file[:path],
              :name => method.to_s.gsub("self.", ""),
              :line_number => file[:content].slice(0, file[:content].index(method.to_s)).count("\n") + 1
            }
          end
        end
        
        methods.reject do |method|
          method[:name].empty? || method[:name] == "initialize"
        end
      end
      
      def self.count_method_calls_for(files, method_name)
        method_call_pattern = Regexp.new("(:#{method_name}|^#{method_name}|(def)?[^A-Za-z0-9_]#{method_name})")
        method_calls = []
        
        files.each do |file|
          method_calls.concat file[:content].scan method_call_pattern
        end

        method_calls = method_calls.map do |method|
          method.to_s
        end

        method_calls = method_calls.reject do |method|
          method.match /^def/
        end

        return method_calls.count
      end
      
    end
  end
end