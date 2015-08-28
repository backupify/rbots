require "rbots/brain"
require "rbots/plugin/deploy_queue/deploy"

module Rbots::Plugin::DeployQueue
  class Queue
    include Rbots::Brain

    attr_reader :id

    def initialize(id)
      @id = id
      @queue = fetch rescue []
    end

    def add(deploy)
      brain.rpush(deploy.to_json)
      @queue << deploy
      deploy
    end

    def brain
      self.class.brain
    end

    def cache_key
      @cache_key ||= "#{self.class.name}::#{@id.to_s}"
    end

    def find_by(opts)
      @queue.detect do |deploy|
        opts.all? do |key, value|
          deploy.send(key) == value
        end
      end
    end

    def load
      brain.lrange(cache_key, 0, -1)
    end

    def pin(deploy)
    end

    def remove(deploy)
      brain.lrem(cache_key, 1, deploy.to_json)
      deploy
    end
  end
end
