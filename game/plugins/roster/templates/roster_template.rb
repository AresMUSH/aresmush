module AresMUSH
  module Roster
    class RosterTemplate < AsyncTemplateRenderer
      include TemplateFormatters
      
      def initialize(roster, page, client)
        @roster = roster
        @page = page
        super client
      end
      
      def build
        list = []
        list << t('roster.roster_column_titles')
        list << "%l2"
        @roster.each do |r|
          roster_char = r.character          
          list << char_entry(roster_char, r)
        end
        BorderedDisplay.paged_list(list, @page, 25, t('roster.roster_title'))
      end
      
      def char_entry(char, roster_entry)
        "#{char_name(char)} #{char_app(char)}   #{roster_contact(roster_entry)}"
      end
      
      def char_name(char)
        char.name.ljust(30)
      end
      
      def char_app(char)
        app = char.is_approved? ? t('global.y') : t('global.n')
        center(app, 10)
      end
      
      def roster_contact(roster_entry)
        roster_entry.contact
      end
    end
  end
end