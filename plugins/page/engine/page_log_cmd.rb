module AresMUSH
  module Page
    class PageLogCmd
      include CommandHandler

      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if (enactor.is_monitoring?(model))            
            template = BorderedListTemplate.new enactor.page_monitor[model.name], t('page.page_log_title', :name => model.name)
            client.emit template.render
          else
            client.emit_failure t('page.not_monitored', :name => self.name)
          end
        end
      end
    end
  end
end
