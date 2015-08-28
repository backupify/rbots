module Rbots::Plugin::DeployQueue
  class Deploy
    attr_reader :code, :description, :state, :user

    def initialize(attrs)
      @code = attrs[:code] || ""
      @description = attrs[:description] || ""
      @state = :waiting
      @user = attrs[:user] || raise(ArgumentError, ":user is required")
    end

    def to_json
      {
        "code" => code,
        "description" => description,
        #"state" => state.to_s,
        "user" => user,
      }.to_json
    end

    def start
      @state = :in_progress
    end

    def verify
      @state = :complete
    end
  end
end
