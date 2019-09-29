module AresMUSH  

  module Migrations
    class MigrationBeta63Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Cleaning up achievement migrations."
       
        Character.all.each do |c|
          c.achievements.each do |achievement|
            if (achievement.name =~ /fs3_joined_combat_/)
              achievement.delete
            end

            if (achievement.name =~ /scene_participant_/)
              count = achievement.name.split('_').last.to_i
              if (count > 0)
                achievement.delete
              end
            end
            
            if (achievement.name =~ /cookie_received_/)
              achievement.delete
            end
          end
          
          scenes = Scene.all.select { |s| s.completed && s.participants.include?(c) }
          c.update(scenes_participated_in: scenes.map { |s| "#{s.id}" })
          
        end
        
        Global.logger.debug "AresCentral now uses https."
        config = DatabaseMigrator.read_config_file("arescentral.yml")
        config['arescentral']['arescentral_url'] = 'https://arescentral.aresmush.com'
        DatabaseMigrator.write_config_file("arescentral.yml", config)
      end 
    end
  end
end