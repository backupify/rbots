require "test_helper"

module Rbots::Test
  class RbotsTest < Rbots::TestCase
    context "Rbots module" do
      should "have a version" do
        refute_nil ::Rbots::VERSION
      end
    end
  end
end
