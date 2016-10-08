module AresMUSH
  module Pose
    class CronEventHandler
      def on_event(event)
        #config = Global.read_config("pose", "cron")
        #return if !Cron.is_cron_match?(config, event.time)

        # Don't clear poses in rooms with active people.
        active_rooms = Global.client_monitor.logged_in.map { |client, char| char.room }

        rooms = Room.all.select { |r| r.poses && !r.poses.empty? }
        rooms.each do |r|
          next if active_rooms.include?(r)
          
          Global.logger.debug "Clearing poses from #{r.name}."
          r.poses = []
          r.pose_order = {}
          r.repose_on = true
          r.save
        end
        
        rooms = Room.all.select { |r| !r.repose_on && r.room_type == "IC" }
        rooms.each do |r|
          next if active_rooms.include?(r)

          Global.logger.debug "Enabling repose in #{r.name}."
          r.repose_on = true
          r.save
        end
      end
    end
  end
end