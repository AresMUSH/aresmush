module AresMUSH
  module FS3Luck
    class LuckAwardCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name, :luck

      def initialize
        self.required_args = ['name', 'luck']
        self.help_topic = 'luck'
        super
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = trim_input(cmd.args.arg1)
        self.luck = trim_input(cmd.args.arg2)
      end
      
      def check_luck
        return t('fs3luck.invalid_luck_points') if !self.luck.is_integer?
        return nil
      end
      
      def check_can_award
        return nil if FS3Luck.can_manage_luck?(client.char)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          model.luck = model.luck + self.luck.to_i
          model.save
          Global.logger.info "#{self.luck} Luck Points Awarded by #{client.name} to #{model.name}"
          client.emit_success t('fs3luck.luck_awarded', :name => model.name, :luck => self.luck)
        end
      end
    end
  end
end
