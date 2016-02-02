require "yaml"
require "resolv"

module Rbots::Plugin
  class NoDeploy
    include Hipbot::Plugin
    include Rbots::Brain

    DISABLE_DESC = "disable deploys to <host ip> - Disable deploys to workers on a host machine with a matching IP"
    ENABLE_DESC = "enable deploys to <host ip> - Enable deploys to workers on a host machine with a matching IP"
    LIST_DESC = "list no deploy - List worker machines that are currently on the no deploy list"

    DISABLE_LAMBDA = lambda do |entities|
      names = find_worker_names(entities)
      if names.empty?
        reply("I'm sorry, Dave. I don't know who you're talking about.")
        return
      end
      toggle_hosts(names, :enabled => false)
      reply("Disabled deploys to #{names.join(", ")}")
    end

    ENABLE_LAMBDA = lambda do |entities|
      names = find_worker_names(entities)
      if names.empty?
        reply("I'm sorry, Dave. I don't know who you're talking about.")
        return
      end
      toggle_hosts(names, :enabled => true)
      reply("Enabled deploys to #{names.join(", ")}")
    end

    LIST_LAMBDA = lambda do
      reply("The following hosts are on the no deploy list: #{disabled_hosts.join(", ")}")
    end

    desc(DISABLE_DESC)
    on(/(?:@[^ ]+ )?(?:disable deploys? to) (.*)/i, &DISABLE_LAMBDA)

    desc(ENABLE_DESC)
    on(/(?:@[^ ]+ )?(?:enable deploys? to) (.*)/i, &ENABLE_LAMBDA)

    desc(LIST_DESC)
    on(/(?:@[^ ]+ )?(?:list no deploy)/i, &LIST_LAMBDA)

    def brain
      self.class.brain
    end

    def disabled_hosts
      Rbots::Brain.brain.smembers("no_deploy")
    end

    def extract_name(entity)
      if is_ip?(entity)
        worker_name_map.fetch(entity)
      elsif known_hosts.include?(entity)
        entity
      else
        nil
      end
    end

    def find_worker_names(names_or_ips)
      collection = names_or_ips.split(/,/)
      collection.map! { |name_or_ip| extract_name(name_or_ip.strip) }
      collection.compact!
      collection
    end

    def is_ip?(str)
      Resolv::IPv4::Regex === str
    end

    def known_hosts
      @known_hosts ||= Set.new(worker_name_map.values.flatten)
    end

    def toggle_hosts(*names, options)
      if options[:enabled]
        brain.srem("no_deploy", *names)
      else
        brain.sadd("no_deploy", *names)
      end
    end

    def worker_name_map
      @worker_name_map ||= YAML.load_file("/root/ip_map.yml")
    end
  end
end
