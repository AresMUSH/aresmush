module AresMUSH
  module Pose
    def self.emit_pose(enactor, pose, is_emit, is_ooc, place_name = nil)
      room = enactor.room
      
      if (is_ooc)
        color = Global.read_config("pose", "ooc_color")
        pose = "#{color}<OOC>%xn #{pose}"
      end
      
      Global.client_monitor.logged_in.each do |client, char|
        next if char.room != enactor.room
        client.emit Pose.custom_format(pose, char, enactor, is_emit, is_ooc, place_name)
      end
      
      if (!is_ooc)
        Global.dispatcher.queue_event PoseEvent.new(enactor, pose, is_emit, is_ooc)
        enactor.room.update_pose_order(enactor.name)
        Pose.notify_next_person(enactor.room)
      end
    end
        
    def self.notify_next_person(room)
      return if room.pose_order.count < 3
        
      poses = room.sorted_pose_order
            
      next_up_name = poses.first[0]
      next_up_char = Character.find_one_by_name(next_up_name)
      
      if ((next_up_char.room != room) || !next_up_char.client)
        enactor_room.remove_from_pose_order(next_up_name)
        Pose.notify_next_person(room)
      elsif (next_up_char.pose_nudge && !next_up_char.pose_nudge_muted)
        next_up_char.client.emit_ooc t('pose.pose_your_turn')      
      end
    end
    
    def self.custom_format(pose, char, enactor, is_emit = false, is_ooc = false, place_name = nil)
      nospoof = ""
      if (is_emit && char.pose_nospoof)
        nospoof = "%xc%% #{t('pose.emit_nospoof_from', :name => enactor.name)}%xn%R"
      end
      
      if (place_name)
        same_place = (char.place ? char.place.name : nil) == place_name
        place_title = Places::Api.place_title(place_name, same_place)
      else
        place_title = is_ooc ? "" : enactor.place_title(char)
      end
      
      quote_color = char.pose_quote_color
      if (is_ooc || quote_color.blank?)
        colored_pose = pose
      else
        matches = pose.scan(/([^"]+)?("[^"]+")?/)
        colored_pose = ""
        matches.each do |m| 
          if (m[0])
            colored_pose << "#{m[0]}"
          end
          if (m[1])
            colored_pose << "#{quote_color}#{m[1]}%xn"
          end
        end
      end
      
      "#{char.pose_autospace}#{nospoof}#{place_title}#{colored_pose}"
    end
    
  end
end