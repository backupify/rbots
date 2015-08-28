require "redis"

module Rbots
  module Brain
    def self.brain
      @brain ||= Redis.new
    end

    def self.included(includer)
      includer.extend(ClassMethods)
    end

    module ClassMethods
      def brain
        Rbots::Brain.brain
      end
    end
  end
end
