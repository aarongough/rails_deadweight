require File.dirname(__FILE__) + '/spec_helper'

describe RailsDeadweight::ProjectParser do
  describe "#get_defined_methods" do
    before :each do
      example_code = <<-EOD
        def method_1
          # does nothing
        end
        
        def method_2(params)
        end
        
        def method3(params) puts foo; end
      EOD
      
      @project_parser = RailsDeadweight::ProjectParser.new(example_code)
    end
    
    it "should return an array of methods that are defined by the ruby code" do
      methods = @project_parser.get_defined_methods
      
      methods.count.should == 3
      methods.should include "method_1"
      methods.should include "method_2"
      methods.should include "method_3"
    end
  end
  
  describe "#count_method_calls_for" do
    before :each do
      example_code = <<-EOD
        method_1()
        foo = method_1
        foo = method_1()
        
        bar = "#{method_2}"
        
        baz = mmethod_3
      EOD
      
      @project_parser = RailsDeadweight::ProjectParser.new(example_code)
    end
    
    it "should return the number of times a method is called" do
      count = @project_parser.count_method_calls_for "method_1"
      count.should == 3
    end
    
    it "should detect method calls inside string interpolation" do
      count = @project_parser.count_method_calls_for "method_2"
      count.should == 1
    end
    
    it "should not return a method call instance for a misspelled method name" do
      count = @project_parser.count_method_calls_for "method_3"
      count.should == 0
    end
  end
end