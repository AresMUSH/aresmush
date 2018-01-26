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
          if (room.scene.temp_room)
            if (room.scene.private_scene)
              return "(S#{room.scene.id}) #{t('who.private')}"
            else
              return "(S#{room.scene.id})#{name.after('-')} %xg<#{t('who.public')}>%xn"
            end
          else
            if (room.scene.private_scene)
              return name
            else
              return "#{name}  %xg<#{t('who.public')}>%xn"
            end
          end
        else
          return name
        end
      end
      
      def room_groups
        groups = {}
        self.online_chars.each do |c|
          room = room_name(c)
          idle = c.is_afk? || Status.is_idle?(Login.find_client(c))
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