module AresMUSH  

  module Migrations
    class MigrationBeta75Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Add new line skins."
        config = DatabaseMigrator.read_config_file("skin.yml")
        if (!config['skin']['line_with_text'])
          config['skin']['line_with_text'] = {
            "default" => {
              "color" => config['skin']['line_with_text_color'] || "%x!",
              "pattern" => config['skin']['line_with_text_padding'] || "-",
              "text_position" => 5,
              "left_bracket" => '[ ',
              "right_bracket" => ' ]',
            }
          }
          config.delete 'line_with_text_color'
          config.delete 'line_with_text_padding'
        end
        DatabaseMigrator.write_config_file("skin.yml", config)
        
        if (!Global.read_config('emoji', 'emoji'))
          default_emoji = DatabaseMigrator.read_distr_config_file("emoji.yml")
          DatabaseMigrator.write_config_file("emoji.yml", default_emoji)
        end
        
        Global.logger.debug "Add max pts advantages."
        config = DatabaseMigrator.read_config_file("fs3skills_chargen.yml")
        config['fs3skills']['max_points_on_advantages'] = 12
        DatabaseMigrator.write_config_file("fs3skills_chargen.yml", config)
        
        Global.logger.debug "Add max pts advantages."
        config = DatabaseMigrator.read_config_file("fs3skills_xp.yml")
        config['fs3skills']['advantage_dots_beyond_chargen_max'] = 2
        DatabaseMigrator.write_config_file("fs3skills_xp.yml", config)
        
      end 
    end
  end
end