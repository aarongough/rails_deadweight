# -*- encoding: utf-8 -*-
require File.expand_path("../lib/rails_deadweight/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "rails_deadweight"
  s.version     = RailsDeadweight::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Aaron Gough"]
  s.email       = ["aaron@aarongough.com"]
  s.homepage    = "http://github.com/aarongough/rails_deadweight"
  s.summary     = "Find unused classes and methods in your Rails application"
  s.description = "Find unused classes and methods in your Rails application"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "rails_deadweight"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec", "~> 2"
  s.add_development_dependency "rake"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end