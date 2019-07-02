module AresMUSH
  class PoseEvent
    attr_accessor :enactor_id, :pose, :is_emit, :is_ooc, :is_setpose, :room_id, :place_name
    def initialize(enactor, pose, is_emit, is_ooc, is_setpose, room, place_name)
      @enactor_id = enactor.id
      @pose = pose
      @is_emit = is_emit
      @is_ooc = is_ooc
      @is_setpose = is_setpose
      @room_id = room.id
      @place_name = place_name
    end
  end
end