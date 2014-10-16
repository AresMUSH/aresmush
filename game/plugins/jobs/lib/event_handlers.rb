module AresMUSH
  module Jobs
    class JobEventHandler
      include Plugin
      
      def on_unhandled_error_event(event)
        return if !Global.config['jobs']['report_errors']
        
        Jobs.create_job(Global.config['jobs']['error_category'], 
          t('jobs.unhandled_error_title'), 
          t('jobs.unhandled_error_message', :message => event.message), 
          Game.master.system_character)
      end
    end
      
  end
end