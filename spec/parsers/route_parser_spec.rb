require File.dirname(__FILE__) + '/../spec_helper'

describe RailsDeadweight::Parsers::RouteParser do  
  describe ".count_routes_for_action" do
    it "should count routes pointing to an action" do
      routes = "
        range_video GET /videos/:id/range(.:format)        {:action=>\"method_1\", :controller=>\"videos\"}
        video_video GET /videos/:id/video(.:format)        {:action=>\"method_1\", :controller=>\"videos\"}
      "

      count = RailsDeadweight::Parsers::RouteParser.count_routes_for_action(routes, "method_1")
      count.should == 2
    end

    it "should return zero if there are no routes pointing to the action" do
      routes = "
        range_video GET /videos/:id/range(.:format)        {:action=>\"method_1\", :controller=>\"videos\"}
      "

      count = RailsDeadweight::Parsers::RouteParser.count_routes_for_action(routes, "method_2")
      count.should == 0
    end

    it "should raise exception when unable to parse routes" do
      routes = "
        (in /Users/aarongough/work/ror_analytics)
        Missing the Rails 2.3.5 gem. Please `gem install -v=2.3.5 rails`, update your RAILS_GEM_VERSION setting in config/environment.rb for the Rails version you do have installed, or comment out RAILS_GEM_VERSION to use the latest version installed.
      "

      lambda {
        RailsDeadweight::Parsers::RouteParser.count_routes_for_action(routes, "method_1")
      }.should raise_error
    end
  end
  
  describe ".count_routes_for_controller" do
    it "should count routes pointing to a controller" do
      routes = "
        range_video GET /videos/:id/range(.:format)        {:action=>\"method_1\", :controller=>\"videos\"}
        video_video GET /videos/:id/video(.:format)        {:action=>\"method_1\", :controller=>\"videos\"}
      "

      count = RailsDeadweight::Parsers::RouteParser.count_routes_for_controller(routes, "VideosController")
      count.should == 2
    end

    it "should return zero if there are no routes pointing to the action" do
      routes = "
        range_video GET /videos/:id/range(.:format)        {:action=>\"method_1\", :controller=>\"videos\"}
      "

      count = RailsDeadweight::Parsers::RouteParser.count_routes_for_controller(routes, "FooController")
      count.should == 0
    end

    it "should raise exception when unable to parse routes" do
      routes = "
        (in /Users/aarongough/work/ror_analytics)
        Missing the Rails 2.3.5 gem. Please `gem install -v=2.3.5 rails`, update your RAILS_GEM_VERSION setting in config/environment.rb for the Rails version you do have installed, or comment out RAILS_GEM_VERSION to use the latest version installed.
      "

      lambda {
        RailsDeadweight::Parsers::RouteParser.count_routes_for_controller(routes, "BarController")
      }.should raise_error
    end
  end
end