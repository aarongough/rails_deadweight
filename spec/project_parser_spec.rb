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
      
      @project_parser = RailsDeadweight::ProjectParser.new(example_code, "/blah/foo")
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
    it "should detect method calls at start of line" do
      example_code = <<-EOD
        method_1()
        method_1
      EOD
      @project_parser = RailsDeadweight::ProjectParser.new(example_code, "/blah/foo")
      
      count = @project_parser.count_method_calls_for "method_1"
      count.should == 2
    end
    
    it "should detect method call on object" do
      example_code = <<-EOD
        Blah.method_1()
        Blah.method_1
      EOD
      @project_parser = RailsDeadweight::ProjectParser.new(example_code, "/blah/foo")
      
      count = @project_parser.count_method_calls_for "method_1"
      count.should == 2
    end
    
    it "should detect method call after assignment" do
      example_code = <<-EOD
        foo = method_1()
        foo = method_1
      EOD
      @project_parser = RailsDeadweight::ProjectParser.new(example_code, "/blah/foo")
      
      count = @project_parser.count_method_calls_for "method_1"
      count.should == 2
    end
    
    it "should detect method call in expression" do
      example_code = <<-EOD
        foo = blah(method_1())
        foo = blah(method_1)
      EOD
      @project_parser = RailsDeadweight::ProjectParser.new(example_code, "/blah/foo")
      
      count = @project_parser.count_method_calls_for "method_1"
      count.should == 2
    end
    
    it "should detect method calls inside string interpolation" do
      example_code = <<-EOD
        bar = "\#{method_2}"
      EOD
      @project_parser = RailsDeadweight::ProjectParser.new(example_code, "/blah/foo")
      
      count = @project_parser.count_method_calls_for "method_2"
      count.should == 1
    end
    
    it "should not return a method call instance for a misspelled method name" do
      example_code = <<-EOD
        baz = mmethod_3
      EOD
      @project_parser = RailsDeadweight::ProjectParser.new(example_code, "/blah/foo")
      
      count = @project_parser.count_method_calls_for "method_3"
      count.should == 0
    end
    
    it "should detect usage of method name in filters" do
      example_code = <<-EOD
        before_filter :method_4
        around_filter :method_4
        after_filter  :method_4
      EOD
      @project_parser = RailsDeadweight::ProjectParser.new(example_code, "/blah/foo")
      
      count = @project_parser.count_method_calls_for "method_4"
      count.should == 3
    end
  end
  
  describe "#count_routes_for" do
    it "should count routes pointing to an action" do
      RailsDeadweight::ProjectRoutes.should_receive(:get_routes_for).with("/blah/foo").and_return("
           range_video GET /videos/:id/range(.:format)        {:action=>\"method_1\", :controller=>\"videos\"}
           video_video GET /videos/:id/video(.:format)        {:action=>\"method_1\", :controller=>\"videos\"}
      ")
      @project_parser = RailsDeadweight::ProjectParser.new("example_code", "/blah/foo")
      
      count = @project_parser.count_routes_for "method_1"
      count.should == 2
    end
    
    it "should return zero if there are no routes pointing to the action" do
      RailsDeadweight::ProjectRoutes.should_receive(:get_routes_for).with("/blah/foo").and_return("
           range_video GET /videos/:id/range(.:format)        {:action=>\"method_1\", :controller=>\"videos\"}
           video_video GET /videos/:id/video(.:format)        {:action=>\"method_1\", :controller=>\"videos\"}
      ")
      @project_parser = RailsDeadweight::ProjectParser.new("example_code", "/blah/foo")
      
      count = @project_parser.count_routes_for "method_2"
      count.should == 0
    end
  end
end