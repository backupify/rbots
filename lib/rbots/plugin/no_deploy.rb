require "yaml"

module Rbots::Plugin
  class NoDeploy
    include Hipbot::Plugin
    include Rbots::Brain

    DISABLE_DESC = "disable deploys to <host ip> - Disable deploys to workers on a host machine with a matching IP"
    ENABLE_DESC = "enable deploys to <host ip> - Enable deploys to workers on a host machine with a matching IP"
    LIST_DESC = "list no deploy - List worker machines that are currently on the no deploy list"

    desc(DISABLE_DESC)
    on(/(?:@[^ ]+ )?(?:disable deploys? to) (.*)/i) do |ip|
      brain = Rbots::Brain.brain
      names = worker_names_for_ip(ip)
      names = [ip] if names.empty?
      names.each do |worker_name|
        brain.sadd("no_deploy", worker_name)
      end
      reply("Disabled deploys to #{names.join(", ")}")
    end

    desc(ENABLE_DESC)
    on(/(?:@[^ ]+ )?(?:enable deploys? to) (.*)/i) do |ip|
      names = worker_names_for_ip(ip)
      brain = Rbots::Brain.brain
      names = [ip] if names.empty?
      names.each do |worker_name|
        brain.srem("no_deploy", worker_name)
      end
      reply("Enabled deploys to #{names.join(", ")}")
    end

    desc(LIST_DESC)
    on(/(?:@[^ ]+ )?(?:list no deploy)/i) do
      names = Rbots::Brain.brain.smembers("no_deploy")
      reply("The following hosts are on the no deploy list: #{names.join(", ")}")
    end

    def worker_names_for_ip(ip)
      names = self.class.worker_name_map[ip]
      return names unless names.nil?
      return [ip] if self.class.worker_name_map.values.flatten.include?(ip)
    end

    def self.worker_name_map
      @worker_name_map ||= YAML.load_file("/root/ip_map.yml")
    end
  end
end
