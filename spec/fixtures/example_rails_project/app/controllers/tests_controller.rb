class TestsController < ApplicationController
  def index
    @foo = Test.new
    @foo.a_method_on_test
  end
end