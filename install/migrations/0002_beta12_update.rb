module AresMUSH
  module Migrations
    class MigrationBeta12Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding wiki configuration."
        
        custom_web = DatabaseMigrator.read_config_file("website.yml")
        custom_web["website"]["wiki_aliases"] = { 'main' => 'home' }
        custom_web["website"]["restricted_pages"] = [ 'home' ]
        
        DatabaseMigrator.write_config_file("website.yml", custom_web)
        
        Global.logger.debug "Adding advantages config."
        default_advantages = DatabaseMigrator.read_distr_config_file("fs3skills_advantages.yml")
        DatabaseMigrator.write_config_file("fs3skills_advantages.yml", default_advantages)
        
        custom_xp = DatabaseMigrator.read_config_file("fs3skills_xp.yml")
        custom_xp['fs3skills']['xp_costs']['advantages'] = {
          0 => 1,
          1 => 4,
          2 => 12
        }
        custom_xp['fs3skills']['allow_advantages_xp'] = false
        DatabaseMigrator.write_config_file("fs3skills_xp.yml", custom_xp)
        
        custom_cg = DatabaseMigrator.read_config_file("fs3skills_chargen.yml")
        custom_cg['fs3skills']['advantages_cost'] = 2
        DatabaseMigrator.write_config_file("fs3skills_chargen.yml", custom_cg)
        
        Global.logger.debug "Adding who config."
        distr_who = DatabaseMigrator.read_distr_config_file("who.yml")
        DatabaseMigrator.write_config_file("who.yml", distr_who)
        
        Global.logger.debug "Adding rank option."
        custom_ranks = DatabaseMigrator.read_config_file("ranks.yml")
        custom_ranks["ranks"]["rank_style"] = "military"
        DatabaseMigrator.write_config_file("ranks.yml", custom_ranks)
                
      end
    end
  end
end