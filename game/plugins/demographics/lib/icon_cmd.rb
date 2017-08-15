module AresMUSH
  module Demographics

    class IconCmd
      include CommandHandler
      
      attr_accessor :icon, :name

      def parse_args
        # Admin version
        if (cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
          self.name = titlecase_arg(args.arg1)
          self.icon = args.arg2
        # Self version
        else
          self.name = enactor.name
          self.icon = cmd.args
        end
      end
      
      def required_args
        [ self.name ]
      end
         
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          model.update(icon: self.icon)
          client.emit_success t('demographics.icon_set')
        end
      end
        
    end
    
  end
end