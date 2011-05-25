require File.dirname(__FILE__) + '/spec_helper'

describe RailsDeadweight::ProjectGlobber do
  describe ".get_globbed_project" do
    before :each do
      @example_rails_app_path = File.dirname(__FILE__) + '/fixtures/example_rails_project'
    end
    
    it "should return all the ruby files in a project's app dir globbed into a single string" do
      project_as_string = RailsDeadweight::ProjectGlobber.get_globbed_project @example_rails_app_path
      
      project_as_string.should include "class Test"
      project_as_string.should include "class TestsController"
      project_as_string.should include "<%= @foo.a_method_on_test %>"
    end   
    
    it "should not glob files that are not in the project's app dir" do
      project_as_string = RailsDeadweight::ProjectGlobber.get_globbed_project @example_rails_app_path
      
      project_as_string.should_not include "def this_is_a_method_that_should_not_be_included"
    end
  end
end