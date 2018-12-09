module AresMUSH
  module Status
    class PlayerBitCmd
      include CommandHandler
      
      attr_accessor :option, :name
      
      def parse_args
        if (cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.name = titlecase_arg(args.arg1)
          self.option = OnOffOption.new(args.arg2)
        else
          self.name = enactor_name
          self.option = OnOffOption.new(cmd.args)
        end
      end
      
      def required_args
        [ self.option, self.name ]
      end
      
      def check_status
        return self.option.validate
      end
      
      def check_can_manage_status
        return nil if self.name == enactor_name
        return t('dispatcher.not_allowed') if !Status.can_manage_status?(enactor)
        return nil
      end
      
      def handle        
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          model.update(is_playerbit: self.option.is_on?)
          client.emit_ooc self.option.is_on? ? t('status.set_playerbit_on') : t('status.set_playerbit_off')
        end
      end
    end
  end
end
