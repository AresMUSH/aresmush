module AresMUSH
  class PoseEvent
    attr_accessor :enactor, :pose, :is_emit, :is_ooc, :is_setpose, :room
    def initialize(enactor, pose, is_emit, is_ooc, is_setpose, room)
      @enactor = enactor
      @pose = pose
      @is_emit = is_emit
      @is_ooc = is_ooc
      @is_setpose = is_setpose
      @room = room
    end
  end
end