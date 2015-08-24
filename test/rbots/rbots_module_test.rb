require "minitest_helper"

module Rbots::Test
  class RbotsModuleTest < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::Rbots::VERSION
    end
  end
end
