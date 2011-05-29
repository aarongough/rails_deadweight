require File.dirname(__FILE__) + '/spec_helper'

describe RailsDeadweight::ProjectCrawler do
  before :each do
    @example_rails_app_path = File.dirname(__FILE__) + '/fixtures/example_rails_project'
  end
  
  describe ".get_project_files" do
    before :each do
      @files = RailsDeadweight::ProjectCrawler.get_project_files(@example_rails_app_path)
      @file_names = @files.map do |file|
        File.basename(file[:path])
      end
    end
    
    it "should return an array of hashes containing file paths and file contents" do
      @files.should be_a Array
      @files.each do |file|
        file.should have_key :path
        file.should have_key :content
      end
    end
    
    it "should return all files in the /app and /lib directories of the project" do
      @file_names.should include "lib_file.rb"
      @file_names.should include "index.html.erb"
      @file_names.should include "test.rb"
      @file_names.should include "tests_controller.rb"
    end
    
    it "should not return files from outside the /app or /lib dirs" do
      @file_names.should_not include "non_project_file.rb"
    end
  end
  
  describe ".get_test_files" do
    before :each do
      @tests = RailsDeadweight::ProjectCrawler.get_test_files(@example_rails_app_path)
      @test_names = @tests.map do |test|
        File.basename(test[:path])
      end
    end
    
    it "should return an array of hashes containing test paths and test contents" do
      @tests.should be_a Array
      @tests.each do |test|
        test.should have_key :path
        test.should have_key :content
      end
    end
    
    it "should return files from the /spec dicrectory" do
      @test_names.should include "test_spec.rb"
    end
    
    it "should return files from the /test directory" do
      @test_names.should include "test_test.rb"
    end
    
    it "should not return files from the /app or /lib directories" do
      @test_names.should_not include "tests_controller.rb"
    end
  end
end