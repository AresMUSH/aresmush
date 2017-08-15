module AresMUSH
  module Page
    class PageIgnoreCmd
      include CommandHandler

      attr_accessor :option, :name
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.option = OnOffOption.new(args.arg2)
      end
      
      def required_args
        [ self.name, self.option ]
      end
      
      def check_status
        return self.option.validate
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if self.option.is_on?
            enactor.page_ignored.add model
            client.emit_success t('page.ignore_added', :name => self.name)
          else
            enactor.page_ignored.delete model
            client.emit_success t('page.ignore_removed', :name => self.name)
          end
        end
      end
    end
  end
end
