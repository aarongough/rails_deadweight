require 'spec_helper'

describe RailsDeadweight::Parsers::MethodParser do
  describe ".get_defined_methods" do
    
    it "should return an array of hashes, each of which contain the file name and line number at which the method is defined" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
        
          def method_1
          end
        EOD
      }]
      
      methods = RailsDeadweight::Parsers::MethodParser.get_defined_methods(@example_files)
      methods.should be_a Array
      methods.each do |method|
        method[:file_path].should == @example_files.first[:path]
        method[:line_number].should == 2
        method[:name].should == "method_1"
      end
    end
    
    it "should detect instance method definition without params" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          def method_1
          end
        EOD
      }]
      
      methods = RailsDeadweight::Parsers::MethodParser.get_defined_methods(@example_files).map{|x| x[:name]}
      methods.should include "method_1"
    end
    
    it "should detect instance method definition with params" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          def method_1()
          end
        EOD
      }]
      
      methods = RailsDeadweight::Parsers::MethodParser.get_defined_methods(@example_files).map{|x| x[:name]}
      methods.should include "method_1"
    end
    
    it "should detect class method definition without params" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          def self.method_1
          end
        EOD
      }]
      
      methods = RailsDeadweight::Parsers::MethodParser.get_defined_methods(@example_files).map{|x| x[:name]}
      methods.should include "method_1"
    end
    
    it "should detect class method definition with params" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          def self.method_1()
          end
        EOD
      }]
      
      methods = RailsDeadweight::Parsers::MethodParser.get_defined_methods(@example_files).map{|x| x[:name]}
      methods.should include "method_1"
    end
    
    it "should detect single line method definition" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          def method_3(params) puts foo; end
        EOD
      }]
      
      methods = RailsDeadweight::Parsers::MethodParser.get_defined_methods(@example_files).map{|x| x[:name]}
      methods.should include "method_3"
    end
    
    it "should not return initialize methods" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          def initialize
          end
        EOD
      }]
      
      methods = RailsDeadweight::Parsers::MethodParser.get_defined_methods(@example_files).map{|x| x[:name]}
      methods.should_not include "initialize"
    end
  end
  
  describe ".count_method_calls_for" do
    
    it "should not detect method definition as method call" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          def method_1
          end
        EOD
      }]
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(@example_files, "method_1")
      count.should == 0
    end
    
    it "should detect method calls at start of line" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          method_1()
          method_1
        EOD
      }]
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(@example_files, "method_1")
      count.should == 2
    end
    
    it "should detect method calls preceeded by logical inverter" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          !method_1()
          !method_1
        EOD
      }]
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(@example_files, "method_1")
      count.should == 2
    end
    
    it "should detect method calls preceeded by starship operator" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          test=>method_1()
          foo=>method_1
        EOD
      }]
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(@example_files, "method_1")
      count.should == 2
    end
    
    it "should detect method call on object" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          Blah.method_1()
          Blah.method_1
        EOD
      }]
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(@example_files, "method_1")
      count.should == 2
    end
    
    it "should detect method calls for methods that end with a question mark" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          Blah.method_1?()
          Blah.method_1?
        EOD
      }]
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(@example_files, "method_1?")
      count.should == 2
    end
    
    it "should detect method calls for methods that end with a exclamation mark" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          Blah.method_1!()
          Blah.method_1!
        EOD
      }]
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(@example_files, "method_1!")
      count.should == 2
    end
    
    it "should detect method call after assignment" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          foo = method_1()
          foo = method_1
        EOD
      }]
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(@example_files, "method_1")
      count.should == 2
    end
    
    it "should detect method call in expression" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          foo = blah(method_1())
          foo = blah(method_1)
        EOD
      }]
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(@example_files, "method_1")
      count.should == 2
    end
    
    it "should detect method calls inside string interpolation" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          bar = "\#{method_2}"
        EOD
      }]
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(@example_files, "method_2")
      count.should == 1
    end
    
    it "should detect usage of method name in symbols" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          before_filter :method_4
          after_save    :method_4
          after_create  :method_4
        EOD
      }]
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(@example_files, "method_4")
      count.should == 3
    end
    
    it "should not return a method call instance for a misspelled method name" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          baz = mmethod_3
        EOD
      }]
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(@example_files, "method_3")
      count.should == 0
    end
    
    it "should not detect a method call preceeded by an underscore" do
      @example_files = [{
        :path => "/test/foo",
        :content => <<-EOD
          foo = test_method_3()
          foo = test_method_3
        EOD
      }]
      
      count = RailsDeadweight::Parsers::MethodParser.count_method_calls_for(@example_files, "method_3")
      count.should == 0
    end
  end
end