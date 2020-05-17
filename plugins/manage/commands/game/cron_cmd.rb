module AresMUSH
  module Manage
    class CronCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
      
      def handle        
        crons = {}
        Global.config_reader.config.each do |section, config|
          config.each do |k, v|
            if (k =~ /_cron/)
              crons["#{section}.#{k}"] = v
            end
          end
        end
        
        list = crons.sort.map { |k, v| print_cron(k, v)}
        template = BorderedListTemplate.new list, t('manage.config_sections')
        client.emit template.render
      end
      
      def print_cron(name, config)
        str = name.ljust(15)
        
        config.each do |k, v|
          str << "%R%T#{k}: #{v.join(", ")} "
        end
        
        str
      end
    end
  end
end