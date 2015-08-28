require "pry"
require "test_helper"
require "rbots/plugin/deploy_queue/queue"

class Rbots::Plugin::DeployQueue::QueueTest < Rbots::TestCase
  Subject = Rbots::Plugin::DeployQueue::Queue
  Deploy =  Rbots::Plugin::DeployQueue::Deploy

  context Subject.name do
    subject { Subject.new(rand(43)) }

    context "#add" do
      should "add the given deploy to the end of the queue" do
        deploy = build_deploy
        subject.brain.expects(:rpush).with(deploy.to_json)
        subject.add(deploy)
      end
    end

    context "#cache_key" do
      should "return the class name with the id" do
        assert_equal "#{subject.class.name}::#{subject.id}", subject.cache_key
      end
    end

    context "#find_by" do
      setup { subject.brain.stubs(:rpush) }

      should "return the first deploy matching the given attributes" do
        user = "Philip J. Fry"
        expected_deploy = build_deploy(:user => user)
        subject.add(build_deploy(:user => "Bender Bending Rodriguez"))
        subject.add(build_deploy(:user => "Turanga Leela"))
        subject.add(expected_deploy)
        subject.add(build_deploy(:user => "Zap Brannigan"))
        assert_equal expected_deploy, subject.find_by(:user => user)
      end

      should "return nil if no matching deploy could be found" do
        subject.add(build_deploy(:user => "Bender Bending Rodriguez"))
        subject.add(build_deploy(:user => "Turanga Leela"))
        assert_nil subject.find_by(:user => "Philip J. Fry")
      end
    end

    context "#load" do
      should "load the full deploy list from redis" do
        subject.brain.expects(:lrange).with(subject.cache_key, 0, -1).returns([])
        subject.load
      end
    end

    context "#remove" do
      should "remove the first instance of the given deploy from the queue" do
        deploy = build_deploy
        subject.brain.expects(:lrem).with(subject.cache_key, 1, deploy.to_json).returns(1)
        subject.remove(deploy)
      end
    end
  end

  def build_deploy(opts = {})
    Deploy.new({
      :code => "https://github.com/backupify/rbots/commit/9b46397fe362101dad11e4337ef35ee4df7f869f",
      :description => "Initial commit",
      :user => "Robert Zimmerman",
    }.merge!(opts))
  end
end
