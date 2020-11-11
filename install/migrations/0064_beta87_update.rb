module AresMUSH  

  module Migrations
    class MigrationBeta87Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding profile order."
        Character.all.each do |c|
          if (!c.profile_order)
            c.update(profile_order: [])
          end
        end
        
        skin = DatabaseMigrator.read_config_file('skin.yml')
        if (skin['skin']['plain'] == "%x!+==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+%xn")
          skin['skin']['plain'] = "------------------------------------------------------------------------------"
          DatabaseMigrator.write_config_file('skin.yml', skin)
        end
      end
    end    
  end
end