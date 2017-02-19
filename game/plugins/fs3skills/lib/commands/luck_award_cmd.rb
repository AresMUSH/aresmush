module AresMUSH
  module FS3Skills
    class LuckAwardCmd
      include CommandHandler
      
      attr_accessor :name, :luck

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = trim_arg(args.arg1)
        self.luck = trim_arg(args.arg2)
      end

      def required_args
        {
          args: [ self.name, self.luck ],
          help: 'luck'
        }
      end
      
      def check_luck
        return t('fs3skills.invalid_luck_points') if !self.luck.is_integer?
        return nil
      end
      
      def check_can_award
        return nil if FS3Skills.can_manage_luck?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          model.award_luck(self.luck.to_i)
          Global.logger.info "#{self.luck} Luck Points Awarded by #{enactor_name} to #{model.name}"
          client.emit_success t('fs3skills.luck_awarded', :name => model.name, :luck => self.luck)
        end
      end
    end
  end
end
