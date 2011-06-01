module RailsDeadweight
  module Utilities
    
    def color_puts(string, color = nil)
      case color
        when :white then print( "\e[37m" )
        when :red then print( "\e[31m" )
        when :green then print( "\e[32m" )
        when :grey then print( "\e[90m")
        when nil then # do nothing
      end
      puts string + "\e[0m"
    end
    
    def progress_report(items_to_process, processed_items)
      print "\e[1A\e[K"
      puts "Progress: #{(processed_items.to_f / items_to_process.to_f * 100).to_i}%"
    end
    
  end
end