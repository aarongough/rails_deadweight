module RailsDeadweight
  module Parsers
    class RouteParser
      
      def self.count_routes_for_action(routes_string, method_name)
        unless routes_string.include? ":action"
          raise "\n\n** Could not get project routes. Please make sure you're running rails_deadweight from within your application's root directory **\n\n"
        end

        route_pattern = Regexp.new(":action=>\"#{method_name}\"")
        return routes_string.scan(route_pattern).count
      end
      
      def self.count_routes_for_controller(routes_string, controller_name)
        controller_name = self.snake_case(controller_name.gsub("Controller", ""))
        
        unless routes_string.include? ":controller"
          raise "\n\n** Could not get project routes. Please make sure you're running rails_deadweight from within your application's root directory **\n\n"
        end

        route_pattern = Regexp.new(":controller=>\"#{controller_name}\"")
        return routes_string.scan(route_pattern).count
      end
      
      private
      
      def self.snake_case(string)
        string.gsub(/([A-Z])/, '_\0').downcase.gsub(/^_/, "")
      end
      
    end
  end
end