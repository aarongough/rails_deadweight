require File.dirname(__FILE__) + '/../spec_helper'

describe RailsDeadweight::Parsers::MethodParser do
  describe ".get_defined_methods" do
    
    it "should detect instance method definition without params" do
      example_code = <<-EOD
        def method_1
        end
      EOD
      
      methods = RailsDeadweight::Parsers::MethodParser.get_defined_methods(example_code)
      methods.should include "method_1"
    end
    
    it "should detect instance method definition with params" do
      example_code = <<-EOD
        def method_1()
        end
      EOD
      
      methods = RailsDeadweight::Parsers::MethodParser.get_defined_methods(example_code)
      methods.should include "method_1"
    end
    
    it "should detect class method definition without params" do
      example_code = <<-EOD
        def self.method_1
        end
      EOD
      
      methods = RailsDeadweight::Parsers::MethodParser.get_defined_methods(example_code)
      methods.should include "method_1"
    end
    
    it "should detect class method definition with params" do
      example_code = <<-EOD
        def self.method_1()
        end
      EOD
      
      methods = RailsDeadweight::Parsers::MethodParser.get_defined_methods(example_code)
      methods.should include "method_1"
    end
    
    it "should detect single line method definition" do
      example_code = <<-EOD
        def method_3(params) puts foo; end
      EOD
      
      methods = RailsDeadweight::Parsers::MethodParser.get_defined_methods(example_code)
      methods.should include "method_3"
    end
    
    it "should not return initialize methods" do
      example_code = <<-EOD
        def initialize
        end
      EOD
      
      methods = RailsDeadweight::Parsers::MethodParser.get_defined_methods(example_code)
      methods.should_not include "initialize"
    end
  end
  
  describe ".count_method_calls_for" do    
    it "should not detect method calls from method definition" do
      example_code = <<-EOD
        def method_1
        end
      EOD
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(example_code, "method_1")
      count.should == 0
    end
    
    it "should detect method calls at start of line" do
      example_code = <<-EOD
        method_1()
        method_1
      EOD
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(example_code, "method_1")
      count.should == 2
    end
    
    it "should detect method calls preceeded by logical inverter" do
      example_code = <<-EOD
        !method_1()
        !method_1
      EOD
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(example_code, "method_1")
      count.should == 2
    end
    
    it "should detect method call on object" do
      example_code = <<-EOD
        Blah.method_1()
        Blah.method_1
      EOD
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(example_code, "method_1")
      count.should == 2
    end
    
    it "should detect method calls for methods that end with a question mark" do
      example_code = <<-EOD
        Blah.method_1?()
        Blah.method_1?
      EOD
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(example_code, "method_1?")
      count.should == 2
    end
    
    it "should detect method calls for methods that end with a exclamation mark" do
      example_code = <<-EOD
        Blah.method_1!()
        Blah.method_1!
      EOD
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(example_code, "method_1!")
      count.should == 2
    end
    
    it "should detect method call after assignment" do
      example_code = <<-EOD
        foo = method_1()
        foo = method_1
      EOD
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(example_code, "method_1")
      count.should == 2
    end
    
    it "should detect method call in expression" do
      example_code = <<-EOD
        foo = blah(method_1())
        foo = blah(method_1)
      EOD
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(example_code, "method_1")
      count.should == 2
    end
    
    it "should detect method calls inside string interpolation" do
      example_code = <<-EOD
        bar = "\#{method_2}"
      EOD
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(example_code, "method_2")
      count.should == 1
    end
    
    it "should not return a method call instance for a misspelled method name" do
      example_code = <<-EOD
        baz = mmethod_3
      EOD
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(example_code, "method_3")
      count.should == 0
    end
    
    it "should detect usage of method name in symbols" do
      example_code = <<-EOD
        before_filter :method_4
        after_save    :method_4
        after_create  :method_4
      EOD
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(example_code, "method_4")
      count.should == 3
    end
  end
end