module AresMUSH
  module Who
    class WhereTemplate < ErbTemplateRenderer
      
      # NOTE!  Because so many fields are shared between the who and where templates,
      # some are defined in a common file.
      include CommonWhoFields
    
      attr_accessor :online_chars, :scene_groups
    
      def initialize(online_chars)
        @online_chars = online_chars
        @scene_groups = build_scene_groups
        
        
        case (Global.read_config("who", "where_style"))
        when "scene"
          template_file = "/where_by_scene.erb"
        when "room"
          template_file = "/where_by_room.erb"
        else
          template_file = "/where.erb"
        end
        
        super File.dirname(__FILE__) + template_file
      end
      
      def append_to_group(groups, key, value)
        if (groups.has_key?(key))
          groups[key] << value
        else
          groups[key] = [value]
        end
      end  
      
      def scene_room_name(char)
        if (char.who_hidden)
          return t('who.hidden')
        end
        
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
        groups['open'] = {}
        
        self.online_chars.each do |c|
          scene = c.room.scene
          room = scene_room_name(c)
          idle = c.is_afk? || Status.is_idle?(Login.find_client(c))
          name = idle ? "%xh%xx#{name(c)}%xn" : name(c)

          if (scene)
            if (scene.private_scene)
              append_to_group(groups['private'], room, name)
            else
              append_to_group(groups['open'], room, name)
            end
          else
            append_to_group(groups['private'], room, name)
          end
        end
        groups
      end
      
      def name(char)
         Demographics.name_and_nickname(char)
      end
       
      def room_name(char)
        room = char.room
        name = Who.who_room_name(char)
        if (room.scene)
          if (room.scene.temp_room)
            if (room.scene.private_scene)
              return t('who.private_scene')
            else
              return "#{name.after('- ')} %xg<#{t('who.open_scene', :scene => room.scene.id)}>%xn"
            end
          else
            if (room.scene.private_scene)
              return name
            else
              return "#{name}  %xg<#{t('who.open_scene', :scene => room.scene.id)}>%xn"
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
      
      def profile_field(char, field, value = nil)
        Profile.general_field(char, field, value)
      end
       
    end 
  end
end