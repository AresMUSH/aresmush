module AresMUSH
  module Scenes
    class SceneLocationCmd
      include CommandHandler
      
      attr_accessor :location, :scene_num
      
      def parse_args
        if (cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        
          self.scene_num = integer_arg(args.arg1)
          self.location = titlecase_arg(args.arg2)
        else
          args = cmd.parse_args(ArgParser.arg1_slash_optional_arg2)

          self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
          self.location = titlecase_arg(cmd.args)
        end
      end
      
      def required_args
        {
          args: [ self.scene_num, self.location ],
          help: 'scenes info'
        }
      end
      
      def handle
        scene = Scene[self.scene_num]
        if (!scene)
          client.emit_failure t('scenes.scene_not_found')    
          return
        end
        
        if (!Scenes.can_manage_scene(enactor, scene))
          client.emit_failure t('dispatcher.not_allowed')
          return
        end
        
        matched_rooms = Room.all.select { |r| format_room_name_for_match(r) =~ /#{self.location.upcase}/ }


        if (matched_rooms.count == 0)
          client.emit_ooc t('scenes.no_room_found')
          description = self.location
        else
          room = matched_rooms.first
          description = "%xh#{room.name}%xn%R#{room.description}"
        end
                
        scene.update(location: self.location)
        message = t('scenes.location_set', :description => description)
        Scenes.add_pose(scene.id, message)

        if (scene.room)
          Describe::Api.create_or_update_desc(scene.room, description)
          scene.room.emit message
        else
          client.emit_ooc message
        end
      end
      
      def format_room_name_for_match(room)
        if (self.location =~ /\//)
          return "#{room.area}/#{room.name}".upcase
        else
          return room.name.upcase
        end
      end
      
    end
  end
end
