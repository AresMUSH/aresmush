module AresMUSH
  module Who
    class WhereSceneTemplate < ErbTemplateRenderer
      
      # NOTE!  Because so many fields are shared between the who and where templates,
      # some are defined in a common file.
      include CommonWhoFields
    
      attr_accessor :online_chars
    
      def initialize(online_chars, client)
        @online_chars = online_chars
                
        @client = client
        
        super File.dirname(__FILE__) + "/where_by_scene.erb"
      end
      
      def append_to_group(groups, key, value)
        if (groups.has_key?(key))
          groups[key] << value
        else
          groups[key] = [value]
        end
      end
      
      def scenes
        Scene.all.select { |s| !s.completed && !s.is_private? && Scenes.participants_and_room_chars(s).any? }
      end
      
      def scene_location(scene)
        scene.location
      end
      
      def scene_participants(scene)
        Scenes.participants_and_room_chars(scene)
        .sort_by { |p| [ (Login.is_online_or_on_web?(p) && (p.room == scene.room)) ? 0 : 1, p.name ]  }
        .each
        .map { |p| name(p, p.room == scene.room) }.join(" ")
      end
      
      def name(char, in_room = true)
        status  = Website.activity_status(char)
        name =  Demographics.name_and_nickname(char)
        
        if (status == 'game-inactive')
          name = "%xh%xx#{name}%xn"
        elsif (status == 'web-inactive')
          name = "%xh%xx#{name}#{Website.web_char_marker}%xn"
        elsif (status == 'web-active')
          name = "#{name}%xh%xx#{Website.web_char_marker}%xn"
        elsif (status == 'game-active')
          if (!in_room)
            name = "%xh%xx#{name}%xn"
          end
          # Else use regular name
        else
          name = "%xh%xx#{name}[#{t('global.offline_status')}]%xn"
        end
        name
      end
       
      def room_name(char)
        room = char.room
        name = Who.who_room_name(char)
        
        if (is_on_web?(char))
          return t('who.web_room')
        end
        
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
      
      def ic_groups
        groups = {}
        self.online_chars.each do |c|
          next if is_on_web?(c)
          next if c.room.scene && !c.room.scene.is_private?
          next if c.room.room_type == "OOC"
          room = room_name(c)
          char_name = name(c)
          append_to_group(groups, room, char_name)
        end
        groups.sort_by { |k, v| [ k == "Private Scenes" ? 1 : 0, k ]}
      end
      
      def ooc_groups
        groups = {}
        self.online_chars.each do |c|
          if (is_on_web?(c))
            append_to_group groups, t('who.web_room'), Demographics.name_and_nickname(c)
          else
            next if c.room.scene && !c.room.scene.is_private?
            next if c.room.room_type != "OOC"
          
            room = room_name(c)
            char_name = name(c)
            append_to_group(groups, room, char_name)
          end
        end
        groups.sort
      end
       
      def is_on_web?(char)
        status  = Website.activity_status(char)
        return status == 'web-inactive' || status == 'web-active'
      end
      
      def section_line(title)
        @client.screen_reader ? title : line_with_text(title)
      end
      
      def scene_room_name(scene)
        scene_codes = ""
        if (scene.room.is_temp_room?)
          scene_codes << "%xc+%xn"
        end
        if (scene.scene_pacing != "Traditional")
          scene_codes << "%xy@%xn"
        end
        
        if (scene.room.is_temp_room?)
          scene_id = left("\##{scene.id}", 5)
          return "#{scene_id} #{scene.location}#{scene_codes}"
        else
          scene_id = left("\##{scene.id}", 5)
          area = scene.room.area ? "#{scene.room.area.name} - " : ""
          return "#{scene_id} #{area}#{scene.room.name}#{scene_codes}"
        end
      end
      
    end 
  end
end