require "pry"

module Rbots::Plugin
  class Pry
    include Hipbot::Plugin

    on(/^pry ?(.*)$/, :handle)

    def handle(arg)
      binding.pry
    end
  end
end
