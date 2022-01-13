module AresMUSH  

  module Migrations
    class MigrationBeta102Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding chargen app notes config."
        config = DatabaseMigrator.read_config_file("chargen.yml")
        config['chargen']['app_notes_prompt'] = "If you want to make any special notes about your application, you can enter them below."
        DatabaseMigrator.write_config_file("chargen.yml", config)     
        
        Global.logger.debug "Deleting empty content tags"
        ContentTag.all
           .select { |t| Website.find_model_for_tag(t) == nil }
           .each { |t| t.delete }
           
      end
    end
  end    
end