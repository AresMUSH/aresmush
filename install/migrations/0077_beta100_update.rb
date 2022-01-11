module AresMUSH  

  module Migrations
    class MigrationBeta100Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Adding profile format."
        config = DatabaseMigrator.read_config_file("profile.yml")
        config['profile']['profile_title_format'] = "bitname"
        DatabaseMigrator.write_config_file("profile.yml", config)
        
        Global.logger.debug "Deleting empty content tags"
        ContentTag.all
           .select { |t| Website.find_model_for_tag(t) == nil }
           .each { |t| t.delete }
        
      end
    end
  end    
end