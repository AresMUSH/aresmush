module AresMUSH
  class PoseEvent
    attr_accessor :enactor, :pose, :is_emit, :is_setpose
    def initialize(enactor, pose, is_emit, is_setpose)
      @enactor = enactor
      @pose = pose
      @is_emit = is_emit
      @is_setpose = is_setpose
    end
  end
end