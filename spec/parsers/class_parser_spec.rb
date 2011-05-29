require File.dirname(__FILE__) + '/../spec_helper'

describe RailsDeadweight::Parsers::ClassParser do
  describe ".get_defined_classes" do
    it "should detect a simple class definition" do
      example_files = [{
        :file_path => "/foo/test",
        :content => <<-EOD
          class Foo
            # no methods
          end
        EOD
      }]
      
      classes = RailsDeadweight::Parsers::ClassParser.get_defined_classes(example_files).map{|x| x[:name]}
      classes.should include "Foo"
    end
    
    it "should detect multiple class definitions" do
      example_files = [{
        :file_path => "/foo/test",
        :content => <<-EOD
          class Foo
            # no methods
          end

          class Bar
            # no methods
          end
        EOD
      }]
      
      classes = RailsDeadweight::Parsers::ClassParser.get_defined_classes(example_files).map{|x| x[:name]}
      classes.should include "Bar"
      classes.should include "Foo"
    end
  end
  
  describe ".count_class_references" do
    it "should detect a reference to the class" do
      example_files = [{
        :file_path => "/foo/test",
        :content => <<-EOD
          FooClass
        EOD
      }]
      
      count = RailsDeadweight::Parsers::ClassParser.count_class_references(example_files, "FooClass")
      count.should == 1
    end
    
    it "should detect the usage of a class method without params" do
      example_files = [{
        :file_path => "/foo/test",
        :content => <<-EOD
          bar = FooClass.new
        EOD
      }]
      
      count = RailsDeadweight::Parsers::ClassParser.count_class_references(example_files, "FooClass")
      count.should == 1
    end
    
    it "should detect the usage of a class method with params" do
      example_files = [{
        :file_path => "/foo/test",
        :content => <<-EOD
          bar = FooClass.foo_bar(1, 2)
        EOD
      }]
      
      count = RailsDeadweight::Parsers::ClassParser.count_class_references(example_files, "FooClass")
      count.should == 1
    end
    
    it "should not detect misspelled class reference" do
      example_files = [{
        :file_path => "/foo/test",
        :content => <<-EOD
          FoodClass
        EOD
      }]
      
      count = RailsDeadweight::Parsers::ClassParser.count_class_references(example_files, "FooClass")
      count.should == 0
    end
  end
end