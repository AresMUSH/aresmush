module AresMUSH
  module Manage
    class ConfigCronCmd
      include CommandHandler

      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
            
      def handle
        crons = {}
        Global.config_reader.config.each do |section, values|
          values.each do |k, v|
            if (k =~ /cron/i )
              if (!crons.has_key?(section))
                crons[section] = {}
              end
              crons[section][k] = v             
            end
          end
        end

        template = ConfigCronTemplate.new(crons)
        client.emit template.render
      end
    end
  end
end