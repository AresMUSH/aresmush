module AresMUSH
  module Pose
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("pose", "cron")
        #return if !Cron.is_cron_match?(config, event.time)

        # Don't clear poses in rooms with active people.
        active_rooms = Global.client_monitor.logged_in_clients.map { |c| c.char.room }

        rooms = Room.where(:poses.not => {"$size"=>0})
        rooms.each do |r|
          next if active_rooms.include?(r)
          
          Global.logger.debug "Clearing poses from #{r.name}."
          r.poses = []
          r.repose_on = true
          r.save!
        end
        
        rooms = Room.where(:repose_on.ne => true, :room_type => "IC")
        rooms.each do |r|
          next if active_rooms.include?(r)

          Global.logger.debug "Enabling repose in #{r.name}."
          r.repose_on = true
          r.save!
        end
      end
    end
  end
end