module AresMUSH
  module Who
    # Fields that are used in both the who and where templates.
    module CommonWhoFields

      # List of connected characters, sorted by room name then character name.
      def chars_by_room
        self.online_chars.sort_by{ |c| [Who.who_room_name(c), c.name] }
      end 
      
      def chars_by_handle
        self.online_chars.sort_by{ |c| c.name }
      end
      
      def online_total
        t('who.players_online', :count => self.online_chars.count)
      end
    
      def ic_total
        ic = self.online_chars.select { |c| c.is_ic? }
        t('who.players_ic', :count => ic.count)
      end
    
      def online_record
        t('who.online_record', :count => Game.master.online_record)
      end
    
      def mush_name
        Global.read_config("game", "name")
      end
    end
  end
end