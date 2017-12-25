module AresMUSH
  module Page
    class PageMonitorCmd
      include CommandHandler

      attr_accessor :option, :name
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.option = OnOffOption.new(args.arg2)
      end
      
      def required_args
        [ self.option, self.name ]
      end
      
      def check_status
        return self.option.validate
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          monitor = enactor.page_monitor || {}
          if (self.option.is_on?)
            monitor[model.name] = []
            client.emit_success t('page.monitor_started', :name => model.name)
          else
            monitor.delete model.name
            client.emit_success t('page.monitor_stopped', :name => model.name)
          end
          enactor.update(page_monitor: monitor)
        end
      end
    end
  end
end
