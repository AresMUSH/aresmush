module AresMUSH  

  module Migrations
    class MigrationBeta89Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Mark coder role restricted."
        role = Role.find_one_by_name("coder")
        if (role)
          role.update(is_restricted: true)
        end
        
        Global.logger.debug "Add job responses."
        config = DatabaseMigrator.read_config_file('jobs.yml')
        if (!config['jobs']['responses']) 
          config['jobs']['responses'] = [
            { 'name' => "Received", 'text' => "Your job has been received. We'll get to it soon." }
          ]
          DatabaseMigrator.write_config_file('jobs.yml', config)
        end
        
        Global.logger.debug "Init event tags."
        Event.all.select { |e| !e.tags }.each { |e| e.update(tags: []) }
        
      end
    end    
  end
end