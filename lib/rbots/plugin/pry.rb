require "pry"

module Rbots::Plugin
  class Pry
    include Robut::Plugin

    def handle(time, nick, message)
      binding.pry if matcher === message.strip
    end

    private

    def matcher
      @matcher ||= /^@#{self.nick} +pry$/
    end
  end
end
