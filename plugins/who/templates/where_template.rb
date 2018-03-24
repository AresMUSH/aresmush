module AresMUSH
  module Who
    class WhereTemplate < ErbTemplateRenderer
      
      # NOTE!  Because so many fields are shared between the who and where templates,
      # they are defined in these two modules, found in other files in this directory.
      include WhoCharacterFields
      include CommonWhoFields
    
      attr_accessor :online_chars, :scene_groups
    
      def initialize(online_chars)
        @online_chars = online_chars
        @scene_groups = build_scene_groups
        
        
        # There are a couple built-in templates - one that shows people grouped by room,
        # and the other that shows a list similar to 'who', and a third grouped by scene. 
        super File.dirname(__FILE__) + "/where_by_scene.erb"
        #super File.dirname(__FILE__) + "/where_by_room.erb"
        #super File.dirname(__FILE__) + "/where.erb"
      end    
      
      def append_to_group(groups, key, value)
        if (groups.has_key?(key))
          groups[key] << value
        else
          groups[key] = [value]
        end
      end  
      
      def scene_room_name(char)
        name = Who.who_room_name(char)
        scene = char.room.scene
        if (scene)
          if (scene.private_scene)
            name = t('who.private_scene')
          else
            name = name.after('- ')
          end
        end
        scene_name = scene ? left("\##{scene.id}", 6) : "      "
        "#{scene_name}#{name}"
      end
        
      def build_scene_groups
        groups = {}
        groups['private'] = {}
        groups['public'] = {}
        
        self.online_chars.each do |c|
          scene = c.room.scene
          room = scene_room_name(c)
          idle = c.is_afk? || Status.is_idle?(Login.find_client(c))
          name = idle ? "%xh%xx#{c.name}%xn" : c.name

          if (scene)
            if (scene.private_scene)
              append_to_group(groups['private'], room, name)
            else
              append_to_group(groups['public'], room, name)
            end
          else
            append_to_group(groups['private'], room, name)
          end
        end
        groups
      end
      
      def room_name(char)
        room = char.room
        name = Who.who_room_name(char)
        if (room.scene)
          if (room.scene.temp_room)
            if (room.scene.private_scene)
              return t('who.private_scene')
            else
              return "#{name.after('- ')} %xg<#{t('who.public_scene', :scene => room.scene.id)}>%xn"
            end
          else
            if (room.scene.private_scene)
              return name
            else
              return "#{name}  %xg<#{t('who.public_scene', :scene => room.scene.id)}>%xn"
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
          append_to_group(groups, room, name)
        end
        groups.sort
      end 
    end 
  end
end