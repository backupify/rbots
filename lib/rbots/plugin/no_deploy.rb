require "yaml"

module Rbots::Plugin
  class NoDeploy
    include Hipbot::Plugin
    include Rbots::Brain

    DISABLE_DESC = "disable deploys to <host ip> - Disable deploys to workers on a host machine with a matching IP"
    ENABLE_DESC = "enable deploys to <host ip> - Enable deploys to workers on a host machine with a matching IP"

    desc(DISABLE_DESC)
    on(/(?:disable deploys to) (.*)/i) do |ip|
      require "pry"
      binding.pry
      names = worker_names_for_ip(ip)
      brain = self.class.brain
      names.each do |worker_name|
        brain.sadd(worker_name)
      end
      reply("Disabled deploys to #{names.join(", ")}")
    end

    desc(ENABLE_DESC)
    on(/(?:enable deploys to) (.*)/i) do |ip|
      names = worker_names_for_ip(ip)
      brain = self.class.brain
      names.each do |worker_name|
        brain.srem(worker_name)
      end
      reply("Enabled deploys to #{names.join(", ")}")
    end

    def worker_names_for_ip(ip)
      self.class.worker_name_map.fetch(ip)
    end

    def self.worker_name_map
      @worker_name_map ||= YAML.load_file("/root/ip_map.yml")
    end
  end
end
