module AresMUSH
  module Pose
    module Api
      def self.autospace(char)
        char.autospace
      end
      
      def self.repose_on(room)
        Pose.repose_on(room)
      end
    end
  end
  
  class PoseEvent
    attr_accessor :client, :pose, :is_emit
    def initialize(client, pose, is_emit)
      @client = client
      @pose = pose
      @is_emit = is_emit
    end
  end
end