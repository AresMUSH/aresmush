module AresMUSH
  module Who
    class WhereTemplate < ErbTemplateRenderer
      
      # NOTE!  Because so many fields are shared between the who and where templates,
      # they are defined in these two modules, found in other files in this directory.
      include WhoCharacterFields
      include CommonWhoFields
    
      attr_accessor :online_chars
    
      def initialize(online_chars)
        @online_chars = online_chars
        
        # There are two built-in templates - one that shows people grouped by room,
        # and the other that shows a list similar to 'who'. 
        super File.dirname(__FILE__) + "/where_by_room.erb"
        #super File.dirname(__FILE__) + "/where.erb"
      end      
      
      def room_name(char)
        room = char.room
        name = Who.who_room_name(char)
        if (room.scene)
          name = "(S#{room.scene.id})#{name.after('-')}"
          privacy = room.scene.private_scene ? "%xr<#{t('who.private')}>%xn" : "%xg<#{t('who.public')}>%xn"
          "#{name} #{privacy}"
        else
          name
        end
      end
      
      def room_groups
        groups = {}
        self.online_chars.each do |c|
          room = room_name(c)
          idle = c.is_afk? || Status::Api.is_idle?(c.client)
          name = idle ? "%xh%xx#{c.name}%xn" : c.name
          if (groups.has_key?(room))
            groups[room] << name
          else
            groups[room] = [name]
          end
        end
        groups.sort
      end 
    end 
  end
end