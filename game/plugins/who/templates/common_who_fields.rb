module AresMUSH
  module Who
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
        center(Global.read_config("server", "name"), 78)
      end
    end
  end
end