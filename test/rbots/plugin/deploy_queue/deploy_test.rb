require "pry"
require "test_helper"
require "rbots/plugin/deploy_queue/deploy"

class Rbots::Plugin::DeployQueue::DeployTest < Rbots::TestCase
  Subject = Rbots::Plugin::DeployQueue::Deploy

  context Subject.name do
    context "#initialize" do
      should "set attributes correctly" do
        opts = default_options

        subject = Subject.new(opts)
        assert_equal opts[:code], subject.code
        assert_equal opts[:description], subject.description
        assert_equal opts[:user], subject.user

        opts.delete(:description)

        subject = Subject.new(opts)
        assert_equal opts[:code], subject.code
        assert_equal "", subject.description
        assert_equal opts[:user], subject.user

        opts = default_options
        opts.delete(:code)

        subject = Subject.new(opts)
        assert_equal "", subject.code
        assert_equal opts[:description], subject.description
        assert_equal opts[:user], subject.user
      end

      should "initialize with a state of :waiting" do
        subject = Subject.new(default_options)
        assert_equal :waiting, subject.state
      end

      should "raise if no user is provided" do
        assert_raises(ArgumentError, ":user is required") do
          opts = default_options
          opts.delete(:user)
          Subject.new(opts)
        end
      end
    end

    context "#to_json" do
      should "serialize the deploy to JSON" do
        subject = Subject.new(default_options)
        subject_json = {
          "code" => subject.code,
          "description" => subject.description,
          #"state" => subject.state,
          "user" => subject.user,
        }.to_json
        assert_equal subject_json, subject.to_json
      end
    end

    context "#start" do
      should "change the state of the deploy to :deploying" do
        subject = Subject.new(default_options)
        assert_equal :waiting, subject.state
        subject.start
        assert_equal :in_progress, subject.state
      end
    end

    context "#verify" do
      should "change the state of the deploy to :complete" do
        subject = Subject.new(default_options)
        subject.verify
        assert_equal :complete, subject.state
      end
    end
  end

  def default_options
    {
      :code => "https://github.com/backupify/rbots/commit/9b46397fe362101dad11e4337ef35ee4df7f869f",
      :description => "Initial commit",
      :user => "Robert Zimmerman",
    }
  end
end
