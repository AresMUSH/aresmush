module AresMUSH
  module Who
    class WhereTemplate < ErbTemplateRenderer
      
      # NOTE!  Because so many fields are shared between the who and where templates,
      # some are defined in a common file.
      include CommonWhoFields
    
      attr_accessor :online_chars
    
      def initialize(online_chars, client)
        @online_chars = online_chars
        @client = client
        
        case (Global.read_config("who", "where_style"))
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
      
      def name(char)
        status  = Website.activity_status(char)
        name =  Demographics.name_and_nickname(char)
        if (status == 'game-inactive')
          name = "%xh%xx#{name}%xn"
        elsif (status == 'web-inactive')
          name = "%xh%xx#{name}#{Website.web_char_marker}%xn"
        elsif (status == 'web-active')
          name = "#{name}%xh%xx#{Website.web_char_marker}%xn"
        end
        name
      end
       
      def room_name(char)
        room = char.room
        name = Who.who_room_name(char)
        
        status  = Website.activity_status(char)
        if (status == 'web-inactive' || status == 'web-active')
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
      
      def room_groups
        groups = {}
        self.online_chars.each do |c|
          room = room_name(c)
          char_name = name(c)
          append_to_group(groups, room, char_name)
        end
        groups.sort
      end
      
      def profile_field(char, field, value = nil)
        Profile.general_field(char, field, value)
      end
       
      def section_line(title)
        @client.screen_reader ? title : line_with_text(title)
      end
    end 
  end
end