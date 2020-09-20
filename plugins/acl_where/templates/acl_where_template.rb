module AresMUSH
  module ACL_Where
    class ACL_WhereTemplate < ErbTemplateRenderer
      
      # NOTE!  Because so many fields are shared between the who and where templates,
      # some are defined in a common file.
      include CommonWhoFields
    
      attr_accessor :online_chars, :scene_groups, :newacltest, :listitem
    
      def initialize(online_chars, client)
        @online_chars = online_chars
        @scene_groups = build_scene_groups
        @client = client
       
	  def top_level_areas
        Rooms.top_level_areas
      end
	   	  
      def children(area, indent_str)
        kids = area.sorted_children
        if kids.empty?
          return nil
        else
          new_indent = "  #{indent_str}"
          kids.map { |a| "%r%t#{indent_str} #{a.name} (#A-#{a.id}) #{children(a, new_indent)}"}.join("")
        end
      end
	  
	  def acl_list_rooms(area, indent_str)
		objects = area.sorted_children
		  [ objects ].each do |list|
			list.each do |a|
				listitem = "#{self.listitem} - #{a.name} (#A-#{a.id}%r"
				kids = a.sorted_children
				  [ kids ].each do |kidlist|
				     kidlist.each do |b|
					    listitem = "#{self.listitem} .%r   **#{b.name} (#A-#{b.id}"
					end	
				  end
			end
		  end
		objects = self.listitem
	  end
        
        case (Global.read_config("who", "where_style"))
        when "scene"
          template_file = "/acl_where_by_scene.erb"
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
        scene = char.room.scene
        status  = Website.activity_status(char)
        if (scene)
			scene_id = left("\##{scene.id}", 6)
			if (scene.temp_room)
			  scene_name = char.room.name.after('- ')
			  area_name = char.room.area ? "#{char.room.area.name} - " : ''
			  return "#{scene_id}#{area_name}#{scene_name}"
			else
			  return "#{scene_id}#{Who.who_room_name(char)}"
			end
        elsif (status == 'web-inactive' || status == 'web-active')
          #return "      #{t('who.web_room')}"
          return "#{scene_id}#{Who.who_room_name(char)}"
        else 
          return "      #{Who.who_room_name(char)}"
        end
        
      end	  
        
      def build_scene_groups
        groups = {}
        groups['private'] = {}
        groups['open'] = {}
        groups['ooc'] = {} #try to catch people who are in OOC areas
        
        self.online_chars.each do |c|
          scene = c.room.scene
          room = scene_room_name(c)
          name = name(c)

          if (c.who_hidden)
            append_to_group(groups['private'],  "      #{t('who.hidden')}", name)
          elsif (scene)
            if (scene.private_scene)
              append_to_group(groups['private'], room, name)
            else
              append_to_group(groups['open'], room, name)
            end
          else
            append_to_group(groups['ooc'], room, name)
          end
        end
        groups
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