require File.dirname(__FILE__) + '/spec_helper'

describe RailsDeadweight::ProjectParser do
  describe "#get_defined_methods" do
    before :each do
      example_code = <<-EOD
        def initialize
        end
      
        def method_1
          # does nothing
        end
        
        def method_2(params)
        end
        
        def method_3(params) puts foo; end
        
        def self.method_4
        end
      EOD
      
      @project_parser = RailsDeadweight::ProjectParser.new(example_code)
    end
    
    it "should return an array of methods that are defined by the ruby code" do
      methods = @project_parser.get_defined_methods
      
      methods.count.should == 4
      methods.should include "method_1"
      methods.should include "method_2"
      methods.should include "method_3"
      methods.should include "method_4"
    end
    
    it "should not return initialize methods" do
      methods = @project_parser.get_defined_methods
      
      methods.should_not include "initialize"
    end
  end
  
  describe "#count_method_calls_for" do
    it "should return the number of times a method is called" do
      example_code = <<-EOD
        method_1()
        foo = method_1
        foo = method_1()
      EOD
      @project_parser = RailsDeadweight::ProjectParser.new(example_code)
      
      count = @project_parser.count_method_calls_for "method_1"
      count.should == 3
    end
    
    it "should detect method calls inside string interpolation" do
      example_code = <<-EOD
        bar = "\#{method_2}"
      EOD
      @project_parser = RailsDeadweight::ProjectParser.new(example_code)
      
      count = @project_parser.count_method_calls_for "method_2"
      count.should == 1
    end
    
    it "should not return a method call instance for a misspelled method name" do
      example_code = <<-EOD
        baz = mmethod_3
      EOD
      @project_parser = RailsDeadweight::ProjectParser.new(example_code)
      
      count = @project_parser.count_method_calls_for "method_3"
      count.should == 0
    end
    
    it "should detect usage of method name in filters" do
      example_code = <<-EOD
        before_filter :method_4
        around_filter :method_4
        after_filter  :method_4
      EOD
      @project_parser = RailsDeadweight::ProjectParser.new(example_code)
      
      count = @project_parser.count_method_calls_for "method_4"
      count.should == 3
    end
  end
end