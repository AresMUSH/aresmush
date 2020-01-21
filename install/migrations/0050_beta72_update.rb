module AresMUSH  

  module Migrations
    class MigrationBeta72Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Collapsing notes."
        Character.all.each do |c|
          if (c.notes.keys.any?)
            new_notes = {}
            c.notes.each do |section, notes|
              new_notes[section] = notes.map { |k, v| "#{k}: #{v}" }.join("%R%R")
            end
            c.update(notes: new_notes)
          end
        end
      end 
    end
  end
end