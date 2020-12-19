module AresMUSH  

  module Migrations
    class MigrationBeta91Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Adding allowable extensions."
        config = DatabaseMigrator.read_config_file("website.yml")
        config['website']['uploadable_extensions'] = [ '.jpg', '.png', '.gif' ]
        DatabaseMigrator.write_config_file("website.yml", config)
        
        
        Global.logger.debug "Giving scene credit."
        missing_scenes = {}
        Scene.shared_scenes.each do |s|
          scene_id = "#{s.id}"
          s.participants.each do |p|
            if (!p.scenes_participated_in.include?(scene_id))
              if (missing_scenes.has_key?(p.name))
                missing_scenes[p.name] << scene_id
              else
                missing_scenes[p.name] = [scene_id]
              end
            end
          end
        end
        missing_scenes.each do |name, scenes|
          char = Character.named(name)
          new_scenes = (char.scenes_participated_in + scenes).uniq
          Global.logger.debug "Resetting #{name} scenes: #{char.scenes_participated_in}"
          char.update(scenes_participated_in: new_scenes)
        end
      end
    end    
  end
end