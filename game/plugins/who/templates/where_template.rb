module AresMUSH
  module Who
    class WhereTemplate
      include TemplateFormatters
      
      # NOTE!  Because so many fields are shared between the who and where templates,
      # they are defined in these two modules, found in other files in this directory.
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