require 'rubygems'
require 'rspec/core/rake_task'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "rails_deadweight"
    gemspec.summary = "Find unused classes and methods in your Rails application"
    gemspec.description = "Find unused classes and methods in your Rails application"
    gemspec.email = "aaron@aarongough.com"
    gemspec.homepage = "http://github.com/aarongough/rails_deadweight"
    gemspec.authors = ["Aaron Gough"]
    gemspec.rdoc_options << '--line-numbers' << '--inline-source'
    gemspec.extra_rdoc_files = ['README.rdoc', 'LICENSE']
    gemspec.add_development_dependency "rspec"
    gemspec.executables << 'ruby_deadweight'
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

desc "Run the specs for ruby_deadweight"
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = "-c"
  t.fail_on_error = false
  t.verbose = false
end