module AresMUSH
  module Migrations
    class MigrationBeta15Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Moving descriptions."
        Character.all.each do |c|
          c.update(outfits: {})
          c.update(details: {})
        end
        Exit.all.each { |e| e.update(details: {} )}
        Room.all.each do |r|
          r.update(details: {})
          r.update(vistas: {})
        end
        
        Description.all.each do |d|
          if (d.parent_type == "AresMUSH::Character")
            model = Character[d.parent_id]
          elsif (d.parent_type == "AresMUSH::Room")
            model = Room[d.parent_id]
          elsif (d.parent_type == "AresMUSH::Exit")
            model = Exit[d.parent_id]
          end
          
          if (d.desc_type == "current")
            model.update(description: d.description)
          elsif (d.desc_type == "short")
            model.update(shortdesc: d.description)
          elsif (d.desc_type == "detail")
            details = model.details
            details[d.name] = d.description
            model.update(details: details)
          elsif (d.desc_type == "outfit")
            outfits = model.outfits
            outfits[d.name] = d.description
            model.update(outfits: outfits)
          else
            Global.logger.warn "Unrecognized description: #{d.inspect}"
          end
        end
        
        Global.logger.debug "Notice settings."
        Character.all.each { |c| c.update(notices_events: true) }
        
        Global.logger.debug "Game setting."
        config = DatabaseMigrator.read_config_file("game.yml")
        config['game']['public_game'] = (config['game']['public_game'] || "").to_s.to_bool
        DatabaseMigrator.write_config_file("game.yml", config)
        
      end
    end
  end
end