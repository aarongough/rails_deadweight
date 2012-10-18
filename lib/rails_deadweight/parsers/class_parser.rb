module RailsDeadweight
  module Parsers
    class ClassParser
      
      CLASS_DEFINITION_PATTERN = /(class\s+[A-Z][A-Za-z0-9]*)/
      
      def self.get_defined_classes(files)
        classes = []
        
        files.each do |file|
          raw_class_definitions = file[:content].scan CLASS_DEFINITION_PATTERN
          
          raw_class_definitions.each do |definition|
            classes << {
              :file_path => file[:path],
              :name => definition.first.to_s.sub(/class\s+/,""),
              :line_number => file[:content].slice(0, file[:content].index(definition.first.to_s)).count("\n") + 1
            }
          end
        end
        
        return classes
      end
      
      def self.count_class_references(files, class_name)
        class_reference_pattern = Regexp.new("(class)?\\s*(#{class_name})")
        class_references = []
        
        files.each do |file|
          class_references.concat(file[:content].scan(class_reference_pattern))
        end

        class_references = class_references.map do |class_reference|
          class_reference.first.to_s
        end

        class_references = class_references.reject do |class_reference|
          class_reference.match /^class/
        end

        return class_references.count
      end
      
    end
  end
end