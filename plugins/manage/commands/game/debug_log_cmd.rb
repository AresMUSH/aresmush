module AresMUSH
  module Manage
    class DebugLogCmd
      include CommandHandler
           
      def check_is_allowed
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
      
      def handle
        logs_path = File.join(AresMUSH.game_path, "logs")
        file = Dir[File.join(logs_path, '**')].sort.reverse.first
        contents = File.readlines(file)
        display = contents.last(25).join("\n")
        
        template = BorderedDisplayTemplate.new display, t('manage.log_file_title')
        client.emit template.render
      end
    end
  end
end
