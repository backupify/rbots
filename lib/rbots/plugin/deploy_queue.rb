require "rbots/plugin/deploy_queue/queue"

module Rubot::Plugin
  module DeployQueue
    include Hipbot::Plugin

    def deploy_queue
      @deploy_queue ||= Queue.new(0)
    end

    module ClassMethods
      def queue
        @queue ||= retrieve_queue
      end

      private

      def retrieve_queue
        Queue.new
    #if !_queue
      #_queue = robot.brain.get("deploy_queue") || []
    #return _queue
      end

      def save_queue
#saveQueue = () ->
  #robot.brain.set("deploy_queue", _queue)
      end
    end

    module InstanceMethods
      def handle(time, nick, message)
        deploy = Deploy.new()
#issued_warnings = 0

#robot.hear /(?:^|!!)(\S+) deploy(.*)/i, (msg) ->
  #user = msg.message.user
  #cmd = msg.match[1].trim()
  #extra = msg.match[2].trim()

  #if cmd == "add"
    #deployAdd(msg, user, extra)
  #else if cmd == "start"
    #deployStart(msg, user, extra)
  #else if cmd == "verify"
    #deployComplete(msg, user, "verified")
  #else if cmd == "remove"
    #deployComplete(msg, user, "removed")
  #else if cmd == "yield"
    #deployYield(msg, user, "yielded")
  #else if cmd == "list" || cmd == "show"
    #null # do nothing
  #else
    #return # assume this wasn't a real attempt at a command

  #deploysShow(queue, msg)
      end

      private

      def add(deploy)
        queue << deploy
#deployAdd = (msg, user, extra) ->
  #if extra && extra != ""
    #queue.push([user.mention_name, user.name, extra, "waiting"])
    #saveQueue()
  #else
    #response = "Please provide a description! e.g. add deploy <description>"
    #msg.send(response)
      end

      def announce
#deployAnnounce = (deploy, extra) ->
  #deploy_message = "#{deploy[1]} deploying #{deploy[2]} #{extra}"
  #robot.messageRoom "24338_deploy@conf.hipchat.com", deploy_message
      end

      def announce_next
#deployAnnounceNext = (msg) ->
  #next = queue[0]
  #msg.send("@#{next[0]} you are next in line to deploy") if next
      end

      def complete(deploy)
#deployComplete = (msg, user, status) ->
  #deploy = first(queue, user)
  #index = queue.indexOf(deploy)
  #if index == -1
    #response = "You have no deploys enqueued!"
  #else
    #if deploy[3] != "deploying/verifying" and status != "removed"
      #deployAnnounce(deploy, "")
    #_queue.splice(index, 1)
    #saveQueue()
    #response = "Deploy #{status}"
  #msg.send(response)
  #deployAnnounceNext(msg)
      end

      def list
#deploysShow = (queue, msg) ->
  #if queue.length == 0
    #msg.emote("Deploy queue is empty!")
  #else
    #counter = 0
    #display = queue.map( (elt) ->
      #counter += 1
      #"#{counter}: <#{elt[1]}> (#{elt[3]}) #{elt[2]} "
    #).join("\n")
    #msg.emote("Deploy queue is:\n #{display}")
      end

      def next_deploy_for_user
#first = (queue, user) ->
  #(elt for elt in queue when elt[0] == user.mention_name)[0]
      end

      def queue
        self.class.queue
      end

      def start
#deployStart = (msg, user, extra) ->
  #if !robot.is_jenkins_healthy && issued_warnings < 3
    #issued_warnings++
    #msg.send("Are you sure you want to do that? My friend Jenkins does not seem to be well. Perhaps you should check on him.")
    #return

  #deploy = first(queue, user)
  #if deploy
    #deploy[3] = "deploying/verifying"
    #deployAnnounce(deploy, extra)
    #issued_warnings = 0
    #response = "Deploy marked as started"
  #else
    #response = "You have no deploys enqueued!"
  #msg.send(response)
      end

      def yield
#deployYield = (msg, user, extra) ->
  #deploy = first(queue, user)
  #if deploy
    #index = queue.indexOf(deploy)
    #deferred = _queue.splice(index, 1)
    #_queue.splice(1, 0, deferred[0])
    #saveQueue()
    #deployAnnounceNext(msg)
  #else
    #response = "You have no deploys enqueued!"
      end
    end
  end
end
