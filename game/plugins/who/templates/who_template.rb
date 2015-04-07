module AresMUSH
  module Who
    
    # Fields used in the who/where templates that relate to displaying
    # a particular character's info
    module WhoCharacterFields
      def char_name(char)
        left(char.name, 22)
      end
    
      def char_position(char)
        left(char.groups["Position"], 19)
      end
    
      # Character's player handle, if they've made it public.
      def char_handle(char)
        name = char.public_handle? ? char.handle : ""
        left(name, 19)
      end
        
      def char_status(char)
        left("#{Status.status_color(char.status)}#{char.status}%xn", 6)
      end
       
      def char_faction(char)
        left(char.groups["Faction"], 15)
      end
    
      # How long a character's been idle, like 20m
      def char_idle(char)
        left("#{TimeFormatter.format(char.client.idle_secs)}", 6)
      end   

      # How long a character's been connected, like 3h
      def char_connected(char)
        left("#{TimeFormatter.format(char.client.connected_secs)}", 6)
      end   
    
      # Name of the room the character is in.
      def char_room(char)
        left(who_room_name(char), 35)
      end 
      
      # This is how the room name is displayed.  It is also used for
      # sorting purposes, so characters are sorted by area then individual rooms,
      # and unfindable characters are sorted together.
      def who_room_name(char)
        if (char.hidden)
          return t('who.hidden')
        end
      
        area = char.room.area.nil? ? "" : "#{char.room.area} - "
        "#{area}#{char.room.name}"
      end
    end
    
    # Fields that are used in both the who and where templates.
    module CommonWhoFields
      attr_accessor :online_chars

      def header(title)
        text = "%l1%R"
        text << "#{mush_name}%R"
        text << "%l2%R"
        text << "%xh#{title}%xn"
        text
      end
      
      def footer
        text = "%r%l2%R%xr#{online_total}%xn"
        text << "%xg#{ic_total}%xn"
        text << "%xb#{online_record}%xn"
        text << "%r%l1"
        text
      end
      
      # List of connected characters, sorted by room name then character name.
      def chars_by_room
        self.online_chars.sort_by{ |c| [who_room_name(c), c.name] }
      end 
      
      # List of connected characters, sorted by handle name (if public) then character name.
      def chars_by_handle
        self.online_chars.sort_by{ |c| [c.public_handle? ? c.handle : "", c.name] }
      end
      
      # Total characers online.
      def online_total
        center(t('who.players_online', :count => self.online_chars.count), 25)
      end
    
      # Total characters online and IC.
      def ic_total
        ic = self.online_chars.select { |c| c.is_ic? }
        center(t('who.players_ic', :count => ic.count), 25)
      end
    
      # Max number of characters ever online
      def online_record
        center(t('who.online_record', :count => Game.online_record), 25)
      end
    
      def mush_name
        center(Global.config['server']['name'], 78)
      end
    end
    
    class WhoTemplate
      include TemplateFormatters
      include WhoCharacterFields
      include CommonWhoFields
    
      def initialize(online_chars)
        self.online_chars = online_chars
      end
      
      def display
        text = header(t('who.who_header'))
        
        chars_by_handle.each do |c|
          text << "%R"
          text << char_status(c)
          text << " "
          text << char_name(c)
          text << " "
          text << char_handle(c)
          text << " "
          text << char_faction(c)
          text << " "
          text << char_connected(c)
          text << " "
          text << char_idle(c)
        end
        
        text << footer()
        
        text
      end
    end 
    
    class WhereTemplate
      include TemplateFormatters
      include WhoCharacterFields
      include CommonWhoFields
    
      def initialize(online_chars)
        self.online_chars = online_chars
      end
      
      def display
        text = header(t('who.where_header'))
        
        chars_by_room.each do |c|
          text << "%R"
          text << char_status(c)
          text << " "
          text << char_name(c)
          text << " "
          text << char_room(c)
          text << " "
          text << char_connected(c)
          text << " "
          text << char_idle(c)
        end
        
        text << footer()
        
        text
      end
    end 
  end
end