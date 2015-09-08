require "rbots/brain"

module Rbots::DataStore::Redis
  extend ActiveSupport::Concern

  attr_reader :id

  included { include Rbots::Brain }

  def initialize(id, auto_load = false)
    @id = id
    attributes if auto_load
  end

  def attributes
    @attributes ||= brain.hgetall(id)
  end

  def brain
    self.class.brain
  end

  def destroy
    brain.del(@id)
  end

  def name
    attributes["name"]
  end

  def name=(value)
    update_attribute("name", value)
    value
  end

  def update_attribute(key, value)
    brain.hset(id, key, value)
    attributes[key] = value
    true
  end

  def update_attributes(attrs)
    brain.hmset(id, *attrs)
    attributes.merge!(attrs)
    true
  end

  module ClassMethods
    def all
      missing_keys = all_keys - cache.keys
      missing_keys.each { |key| create(key) }
      cache.values
    end

    def all_keys
      brain.smembers(cache_key)
    end

    def cache
      @cache ||= Hash.new do |hash, key|
        brain.sadd(cache_key, id)
        hash[key] = create(key)
      end
    end

    def cache_key
      @cache_key ||= "Rbots::#{self.name}"
    end

    def create(id, auto_load = false)
      cache[id] = new(id, auto_load)
    end

    def find(id)
      return cache[id] if cache.key?(id)
      brain.exists(id) && create(id)
    end

    def find_by(attrs)
      all.find do |instance|
        instance_attrs = instance.attributes
        attrs.all? do |key, value|
          instance_attrs[key] == value
        end
      end
    end

    def find_or_create_by(attrs)
      found = find(attrs[:id]) if attrs.key?(:id)
      return found if found
      find_by(attrs) || create(attrs[:id], :auto_load)
    end

    def find_or_initialize_by(attributes)
      find_by(attrs) || create(attrs[:id])
    end

    def where(attrs)
      all.select do |instance|
        instance_attrs = instance.attributes
        attrs.all? do |key, value|
          instance_attrs[key] == value
        end
      end
    end
  end
end
