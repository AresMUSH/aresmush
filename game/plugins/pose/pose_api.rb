module AresMUSH
  module Pose
    module Api
      def self.autospace(char)
        Pose.autospace(char)
      end
      
      def self.repose_on(room)
        Pose.repose_on(room)
      end
      
      def self.reset_repose(room)
        Pose.reset_repose(room)
      end
    end
  end
  
  class PoseEvent
    attr_accessor :enactor, :pose, :is_emit
    def initialize(enactor, pose, is_emit)
      @enactor = enactor
      @pose = pose
      @is_emit = is_emit
    end
  end
end